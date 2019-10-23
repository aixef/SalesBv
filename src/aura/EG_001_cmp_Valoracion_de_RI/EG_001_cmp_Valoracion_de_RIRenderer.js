/*
*Desarrollado por:       Indra
*Autor:                  Alberto Galindo
*Proyecto:               Experiencia Única
*Descripción:            Componente Renderer
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 23-08-2017     |   Alberto Galindo     |           Creación
*/
({
    render: function(component, helper) {
        var result = this.superRender();
        helper.getSObjectName(component);
        return result;
    }
})
