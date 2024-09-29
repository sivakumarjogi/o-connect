import 'dart:developer';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CallBacks {
  InAppWebViewController controller;

  CallBacks({required this.controller});

  String get checkCanvas {
    return '''
    canvas.__eventListeners = {};
      ''';
  }

  Future<void> clearCanvas() async {
    String clearCanvas = '''
          canvas.clear();
          ''';
    await evaluateJs(clearCanvas);
  }

  Future<void> selectDrawingMode() async {
    String drawingJs = '''
    $checkCanvas
    console.log("Drawing");
    canvas.freeDrawingBrush = new fabric.PencilBrush(canvas);
    canvas.isDrawingMode = true;
    canvas.freeDrawingBrush.width = 2;
    canvas.selection = false;
    canvas.freeDrawingBrush.color = "#00aeff";
    canvas.on("mouse:up", function (cursorPos) {
      $canvasJsonSendEvent
    });

''';
    await evaluateJs(drawingJs);
  }

  Future<void> selectEraserMode() async {
    String drawingJs = '''
    $checkCanvas
    canvas.isDrawingMode = true;
    canvas.freeDrawingBrush = new fabric.EraserBrush(canvas);
    canvas.freeDrawingBrush.width = 5;
    canvas.on("mouse:up", function (cursorPos) {
      $canvasJsonSendEvent
    });
''';
    await evaluateJs(drawingJs);
  }

  Future<void> selectSelectionMode() async {
    String drawingJs = '''
        $checkCanvas
        canvas.selection = true;
        canvas.forEachObject(function(o) {
          o.selectable = true;
        });
        canvas.isDrawingMode = false;
        canvas.on('mouse:down', function(options) {
          canvas.selection = true;
        });
        canvas.on('mouse:move', function(options) {
          canvas.selection = false;
        });
        canvas.on("mouse:up", function (cursorPos) {
          $canvasJsonSendEvent
        });
      ''';
    await evaluateJs(drawingJs);
  }

  Future<void> drawFromObjectData({required dynamic objectData}) async {
    String drawingJs = '''
        $checkCanvas
      	canvas.loadFromJSON(JSON.stringify($objectData), function() {
        canvas.renderAll();
        var canvasJson = JSON.stringify(canvas);
        console.log("canvas after data",canvasJson);
        });
      ''';
    await evaluateJs(drawingJs);
  }

  Future<void> undo() async {
    String drawingJs = '''
        $checkCanvas
        var currentCanvasData = canvas.getObjects();
        console.log(currentCanvasData.length);
        if (currentCanvasData.length > 0) {
          var objectData = currentCanvasData[currentCanvasData.length - 1];
          tempObjectData.push(objectData);
          canvas.remove(objectData);
          $canvasJsonSendEvent
        }
   
      ''';
    await evaluateJs(drawingJs);
  }

  Future<void> redo() async {
    String drawingJs = '''
        $checkCanvas
        if (tempObjectData.length > 0) {
          var currentTempObject = tempObjectData[tempObjectData.length - 1];
          console.log(currentTempObject);
          canvas.add(currentTempObject);
          tempObjectData.pop();
          $canvasJsonSendEvent
        }
      ''';
    await evaluateJs(drawingJs);
  }

  String get canvasJsonSendEvent {
    String drawingJs = '''
      var sendCanvasData = {};
      var canvasJson = JSON.stringify(canvas);
      sendCanvasData.canvasData = canvasJson;
      console.log("test ",cursorPos);
      if(cursorPos!=undefined){
        sendCanvasData.cursorData = {
          x: cursorPos.pointer.x,
          y: cursorPos.pointer.y
        };
      }
      window.flutter_inappwebview.callHandler('canvasJsonData', sendCanvasData);
    ''';
    return drawingJs;
  }
  // var parsedJsonData = JSON.parse(canvasJson);
  // sendCanvasData.canvasData = JSON.stringify(JSON.stringify(parsedJsonData));

  // parsedJsonData.objects = [parsedJsonData.objects[parsedJsonData.objects.length-1]]

  Future drawImage({String base64Data = ""}) async {
    String imageCode = '''
        $checkCanvas
      fabric.Image.fromURL('data:image/png;base64,$base64Data', function(img) {
        img.set({
          left: 10,
          top: 10,
          fit:"fill",
          scaleX: 0.1, scaleY: 0.1 ,
        });
        canvas.add(img);
        canvas.renderAll();
        var cursorPos = undefined;
        canvas.on("mouse:up", function (cursorPos) {
          $canvasJsonSendEvent
        });
      });

      ''';
    await evaluateJs(imageCode);
  }

  Future drawText({String textToEnter = ""}) async {
    String imageCode = '''
        $checkCanvas
      canvas.forEachObject(function(o) {
          o.selectable = false;
        });
      canvas.selection = false;
      var textOptions = {
        top: 10,
        left: 10,
        width: 200,
        height: 200,
        fontSize: 22,
        lockScalingX: false,
        lockScalingY: false,
        hasRotatingPoint: false,
        transparentCorners: false,
        cornerSize: 7,
        selectionStart: 0,
        selectionEnd: 18,
      };
      canvas.isDrawingMode = false;
      var _text = new fabric.IText('$textToEnter', textOptions);
      canvas.add(_text);
      canvas.renderAll();
      var cursorPos = undefined;
        $canvasJsonSendEvent

      ''';
    await evaluateJs(imageCode);
  }

  Future<void> downloadCanvasAsImage() async {
    String code = '''
    var canvasBytes = canvas.toDataURL("image/png").replace("img/png", "image/octet-string");
    window.flutter_inappwebview.callHandler('canvasImageStream',canvasBytes);
    ''';
    await evaluateJs(code);
  }

  Future<void> drawRectangle() async {
    String rectDraw = '''
        $checkCanvas
        canvas.selection = false;
        canvas.isDrawingMode = false;
        canvas.forEachObject(function(o) {
          o.selectable = false;
        });
        canvas.freeDrawingBrush.color = "transparent";
        var rectangle, isDown, origX, origY;
        canvas.on('mouse:down', function(o){
            var pointer = canvas.getPointer(o.e);

            isDown = true;
            origX = pointer.x;
            origY = pointer.y;

            rectangle = new fabric.Rect({
                left: origX,
                top: origY,
                fill: 'transparent',
                stroke: 'red',
                strokeWidth: 3,
                selectable: false
            });
            canvas.add(rectangle);
        });
        canvas.on('mouse:move', function(o){
            if (!isDown) return;
            var pointer = canvas.getPointer(o.e);
            if(origX>pointer.x){
                rectangle.set({ left: Math.abs(pointer.x) });
            }
            if(origY>pointer.y){
                rectangle.set({ top: Math.abs(pointer.y) });
            }
            
            rectangle.set({ width: Math.abs(origX - pointer.x) });
            rectangle.set({ height: Math.abs(origY - pointer.y) });
            canvas.renderAll();
        });
        canvas.on('mouse:up', function(cursorPos){
          isDown = false;
          $canvasJsonSendEvent
        });
        ''';
    await evaluateJs(rectDraw);
  }

  Future<void> drawCircle() async {
    String rectDraw = '''
        $checkCanvas   
        canvas.forEachObject(function(o) {
          o.selectable = false;
        });
        canvas.selection = false;
        canvas.isDrawingMode = false;
        canvas.freeDrawingBrush.color = "transparent";
        var circle, isDown, origX, origY;
        canvas.on("mouse:down", function (o) {
          var pointer = canvas.getPointer(o.e);
          isDown = true;
          origX = pointer.x;
          origY = pointer.y;
          circle = new fabric.Circle({
            left: origX,
            top: origY,
            fill: "transparent",
            stroke: "red",
            strokeWidth: 3,
            selectable: false
          });
        });
        canvas.on("mouse:move", function (o) {
          if (!isDown) return;
          var pointer = canvas.getPointer(o.e);
          if (origX > pointer.x) {
            circle.set({ left: Math.abs(pointer.x) });
          }
          if (origY > pointer.y) {
            circle.set({ top: Math.abs(pointer.y) });
          }

          circle.set({ radius: Math.abs(origX - pointer.x) });
          canvas.add(circle);
          canvas.renderAll();
        });
        canvas.on("mouse:up", function (cursorPos) {
          isDown = false;
          $canvasJsonSendEvent
        });
        ''';
    await evaluateJs(rectDraw);
  }

  Future<void> drawTriangle() async {
    String rectDraw = '''
        $checkCanvas   
        canvas.selection = false;
        canvas.isDrawingMode = false;
        canvas.forEachObject(function(o) {
          o.selectable = false;
        });
        canvas.freeDrawingBrush.color = "transparent";
        var triangle, isDown, origX, origY;
        canvas.on("mouse:down", function (o) {
          var pointer = canvas.getPointer(o.e);
          isDown = true;
          origX = pointer.x;
          origY = pointer.y;
          triangle = new fabric.Triangle({
            width:0,
            height:0,
            left: origX,
            top: origY,
            fill: "",
            stroke: "green",
            strokeWidth: 3,
            angle: 0,
            selectable: false
          });

        });
        canvas.on("mouse:move", function (o) {
          if (!isDown) return;
          var pointer = canvas.getPointer(o.e);
          if (origX > pointer.x) {
            triangle.set({ left: Math.abs(pointer.x) });
          }
          if (origY > pointer.y) {
            triangle.set({ top: Math.abs(pointer.y) });
          }

          triangle.set({ width: Math.abs(origX - pointer.x) });
          triangle.set({ height: Math.abs(origY - pointer.y) });
          canvas.add(triangle);
          canvas.renderAll();
        });
        canvas.on("mouse:up", function (cursorPos) {

          isDown = false;
          $canvasJsonSendEvent
        });
        ''';
    await evaluateJs(rectDraw);
  }

  Future<void> drawLine() async {
    String drawLine = '''

      $checkCanvas
      canvas.selection = false;
      canvas.forEachObject(function(o) {
        o.selectable = false;
      });
      canvas.isDrawingMode = false;
      var point1, point2, line, isDown;
      canvas.on("mouse:down", function (options) {
      var point= canvas.getPointer(options.e);
        if (point1 === undefined) {
          point1 = new fabric.Point(point.x, point.y);
          console.log(point1);
          isDown = true;
        }
      });
      canvas.on("mouse:move", function (options) {
        if (!isDown) return;

        var point= canvas.getPointer(options.e);
        if (point1 != undefined) {
          point2 = new fabric.Point(point.x, point.y);
          if (line === undefined) {
            line = new fabric.Line([point1.x, point1.y, point2.x, point2.y], {
              stroke: "blue",
              strokeWidth: 1,
              selectable: false
            });
          } else {
            line.set({
              x2: point2.x,
              y2: point2.y,
            });
          }
          if (point1 != undefined && point2 != undefined) {
            canvas.add(line);
            canvas.renderAll();
          }
        }
      });
      canvas.on("mouse:up", function (cursorPos) {
        isDown = false;
        point1 = undefined;
        point2 = undefined;
        line = undefined;
        $canvasJsonSendEvent
      });
''';
    await evaluateJs(drawLine);
  }

  Future<void> evaluateJs(String jsCode) async {
    var jsDec = await controller.evaluateJavascript(
      source: jsCode,
    );
    log(jsDec.toString());
  }
}
