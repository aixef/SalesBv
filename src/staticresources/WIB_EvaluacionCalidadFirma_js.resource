var sigCapture = null;
var sigCapture2 = null;

$(document).ready(function(e) {

    sigCapture = new SignatureCapture( "signature" );
    sigCapture2 = new SignatureCapture( "signature2" );

    $("#submit").click( onSubmitClick );
    $("#cancel").click( onCancelClick );
});

function onBackClick( event ){
    window.top.location= '/' + "'{!Eval.Id}'";
}

function onSubmitClick( event ) {
    sforce.connection.sessionId = '{!$Api.Session_ID}';
    var query = "SELECT Id, OwnerId From Evaluacion__c WHERE Id = '{!Eval.Id}' limit 1";
    var sig = sigCapture.toString();
    result = sforce.connection.query(query);
    var record = result.getArray("records")[0];

    if(record){

        var insertRecord = new Array();
        var adjunto = new sforce.SObject("Attachment");
        adjunto.ParentId = record.Id;
        adjunto.Body = sig;
        adjunto.ContentType = 'image/jpeg'
        adjunto.name = 'FirmaRepresentante_' + record.Id;
        adjunto.OwnerId = record.OwnerId;

        insertRecord.push(adjunto);

        var res = sforce.connection.create(insertRecord);

        if(res[0].getBoolean("success")){

            sig = sigCapture2.toString();
            insertRecord = new Array();
            adjunto = new sforce.SObject("Attachment");
            adjunto.ParentId = record.Id;
            adjunto.Body = sig;
            adjunto.ContentType = 'image/jpeg'
            adjunto.name = 'FirmaAsesor_' + record.Id;
            adjunto.OwnerId = record.OwnerId;

            insertRecord.push(adjunto);

            res = sforce.connection.create(insertRecord);

            if(res[0].getBoolean("success")){
                alert('La firma fue guardada.');
                window.top.location= '/' + record.Id;
            }else{
                alert('Hubo un error al crear el attachment: ' + res);
            }

        }else{
            alert('Hubo un error al crear el attachment: ' + res);
        }
    }else{
        alert('No se encontraron registros');
    }
}

function onSubmitClick2( event ) {
    sforce.connection.sessionId = '{!$Api.Session_ID}';
    var query = "SELECT Id, OwnerId From Evaluacion__c WHERE Id = '{!Eval.Id}' limit 1";
    var sig = sigCapture.toString();
    result = sforce.connection.query(query);
    var record = result.getArray("records")[0];

    if(record){
    }else{
        alert('No se encontraron registros');
    }
}


function onCancelClick( event ) {
    clearForm();
}

function clearForm() {
    $("#email").val( "" );
    sigCapture.clear();
    sigCapture2.clear();
    $("#feedback").html( "" );
}

function requestSuccess( data, textStatus, jqXHR ) {
    clearForm();
    $("#feedback").html( "Gracias." );
}

function requestError( jqXHR, textStatus, errorThrown ) {
    $("#feedback").html( "Error: " + errorThrown );
}

function verifyEmail() {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test( $("#email").val() );
}

function SignatureCapture(canvasID) {
    this.touchSupported = Modernizr.touch;
    this.canvasID = canvasID;
    this.canvas = $("#"+canvasID);
    this.context = this.canvas.get(0).getContext("2d");
    this.context.strokeStyle = "#FFFFFF";
    this.context.lineWidth = 1;
    this.lastMousePoint = {x:0, y:0};

    this.canvas[0].width = this.canvas.parent().innerWidth();

    if (this.touchSupported) {
        this.mouseDownEvent = "touchstart";
        this.mouseMoveEvent = "touchmove";
        this.mouseUpEvent = "touchend";
    }
    else {
        this.mouseDownEvent = "mousedown";
        this.mouseMoveEvent = "mousemove";
        this.mouseUpEvent = "mouseup";
    }

    this.canvas.bind( this.mouseDownEvent, this.onCanvasMouseDown() );
}

SignatureCapture.prototype.onCanvasMouseDown = function () {
    var self = this;
    return function(event) {
        self.mouseMoveHandler = self.onCanvasMouseMove()
        self.mouseUpHandler = self.onCanvasMouseUp()

        $(document).bind(self.mouseMoveEvent, self.mouseMoveHandler);
        $(document).bind(self.mouseUpEvent, self.mouseUpHandler);

        self.updateMousePosition(event);
        self.updateCanvas(event);
    }
}

SignatureCapture.prototype.onCanvasMouseMove = function () {
    var self = this;
    return function(event) {

        self.updateCanvas(event);
        event.preventDefault();
        return false;
    }
}

SignatureCapture.prototype.onCanvasMouseUp = function (event) {
    var self = this;
    return function(event) {

        $(document).unbind( self.mouseMoveEvent, self.mouseMoveHandler );
        $(document).unbind( self.mouseUpEvent, self.mouseUpHandler );

        self.mouseMoveHandler = null;
        self.mouseUpHandler = null;
    }
}

SignatureCapture.prototype.updateMousePosition = function (event) {
    var target;
    if (this.touchSupported) {
        target = event.originalEvent.touches[0]
    }
    else {
        target = event;
    }

    var offset = this.canvas.offset();
    this.lastMousePoint.x = target.pageX - offset.left;
    this.lastMousePoint.y = target.pageY - offset.top;

}

SignatureCapture.prototype.updateCanvas = function (event) {

    this.context.beginPath();
    this.context.moveTo( this.lastMousePoint.x, this.lastMousePoint.y );
    this.updateMousePosition( event );
    this.context.lineTo( this.lastMousePoint.x, this.lastMousePoint.y );
    this.context.stroke();
}

SignatureCapture.prototype.toString = function () {

    var dataString = this.canvas.get(0).toDataURL("image/png");
    var index = dataString.indexOf( "," )+1;
    dataString = dataString.substring( index );

    return dataString;
}

SignatureCapture.prototype.clear = function () {

    var c = this.canvas[0];
    this.context.clearRect( 0, 0, c.width, c.height );
}