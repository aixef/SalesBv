/**
 * @File Name          : MX_SB_VTS_ValidCorrectNamesASD.cls
 * @Description        : Valida los nombres correctos para productos
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              : BBVA
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 16/6/2019 14:08:29
 * @Modification Log   : Initial Version
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    27/5/2019 11:13:07   Eduardo Hernández Cuamatzi     Initial Version
**/
public virtual with sharing class MX_SB_VTS_ValidCorrectNamesASD {//NOSONAR

    /**
     * MX_SB_VTS_CierreOpp public Constructor
     * @return   Evita error Singleton
     */
    public MX_SB_VTS_ValidCorrectNamesASD() {}//NOSONAR

    /**
     * validProASD Valida nombre correcto para Auto seguro
     * @param  prductUper Nombre en mayúsculas
     * @return            return valor correcto
     */
    public static string validProASD (String producto) {
        final String productCorrect = producto.toUpperCase();
        final String productLabel= System.Label.MX_SB_VTS_AutoSD.toUpperCase();
        String productC = producto;
        if(productCorrect.contains(productLabel)) {
            productC = productCorrect.contains(System.Label.MX_SB_VTS_DINAMICO_LBL) ? System.Label.MX_SB_VTS_PRODUCTO_AUTO_DINAMICO_LBL : productC;
            productC = productCorrect.contains(System.Label.MX_SB_VTS_DINAMICO2_LBL) ? System.Label.MX_SB_VTS_PRODUCTO_AUTO_DINAMICO_LBL : productC;
        }
        return productC;
    }

    /**
     * validProMoto description
     * @param  prductUper Nombre en mayúsculas
     * @return            return valor correcto
     */
    public static string validProMoto (String producto) {
        final String productCorrect = producto.toUpperCase();
        String productC = producto;
        productC = productCorrect.contains(System.Label.MX_SB_VTS_MOTO_LBL) ? System.Label.MX_SB_VTS_SEGURO_MOTO_LBL : productC;
        return productC;
    }

    /**
     * validProFront description
     * @param  prductUper Nombre en mayúsculas
     * @return            return valor correcto
     */
    public static string validProFront (String producto) {
        final String productCorrect = producto.toUpperCase();
        String productC = producto;
        productC = productCorrect.contains(System.Label.MX_SB_VTS_FRONTERIZO_LBL) ? System.Label.MX_SB_VTS_AUTO_FRONTERIZO_LBL : productC;
        return productC;
    }

    /**
     * validProLegal description
     * @param  prductUper Nombre en mayúsculas
     * @return            return valor correcto
     */
    public static string validProLegal (String producto) {
        final String productCorrect = producto.toUpperCase();
        String productC = producto;
        productC = productCorrect.contains(System.Label.MX_SB_VTS_NACIONALIZADO_LBL) ? System.Label.MX_SB_VTS_AUTO_NACIONALIZADO_LBL : productC;
        productC = productCorrect.contains(System.Label.MX_SB_VTS_Legal_LBL) ? System.Label.MX_SB_VTS_AUTO_LEGALIZADO_LBL : productC;
        return productC;
    }

    /**
    * Obtiene un Nombre correcto para producto
    * @param String producto Respuesta String
    */
    public static String validacionProducto(String producto) {
        String correctName = producto;
        correctName = validASD(producto);
        final String vartemASD = correctName;
        correctName = validHogarSeguro(vartemASD);
        return correctName;
    }

    /**
     * validASD valida para productos de Automotriz
     * @param  producto nombre de producto
     * @return          return valor correcto
     */
    public static String validASD(String producto) {
        String correctName = producto;
        correctName = validProASD(producto);
        final String vartem1 = correctName;
        correctName = validProMoto(vartem1);
        final String vartem2 = correctName;
        correctName = validProFront(vartem2);
        final String vartem3 = correctName;
        correctName = validProLegal(vartem3);
        return correctName;
    }

     /**
     * validHogarSeguro Valida nombre correcto para hogar seguro
     * @param  hogarStr Nombre en mayúsculas
     * @return            return valor correcto
     */
    public static string validHogarSeguro (String hogarStr) {
        final String productCorrect = hogarStr.toUpperCase();
        String productC = hogarStr;
        if(productC.contains(System.Label.MX_SB_VTS_Hogar)) {
            productC = productCorrect.contains(System.Label.MX_SB_VTS_DINAMICO_LBL) ? System.Label.MX_SB_VTS_PRODUCTO_HogarDinamico_LBL : productC;
            productC = productCorrect.contains(System.Label.MX_SB_VTS_DINAMICO2_LBL) ? System.Label.MX_SB_VTS_PRODUCTO_HogarDinamico_LBL : productC;
            productC = productCorrect.contains(System.Label.MX_SB_VTS_DINAMICO2_LBL) == false ? System.Label.MX_SB_VTS_Hogar : productC;
        }
        return productC;
    }
}
