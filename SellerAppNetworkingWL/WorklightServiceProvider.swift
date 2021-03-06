//
//  WorklightServiceProvider.swift
//  WorklightServices
//
//  Created by Luis Cuevas on 12/06/17.
//  Copyright © 2017 Deloitte. All rights reserved.
//

import Foundation
import Alamofire


public class WorklightServiceProvider : WorklightServiceProtocol
{
    var manager = SessionManager.default
    
    public enum Environment: Int {
        case Production, QA, Development, Deloitte, Custom, UAT
    }
    
    var environment: Environment = .Production
    var customHostname: String = ""
    var hostname: String {
        switch self.environment
        {
        case .Production:       return "http://172.16.204.118:9195"
        case .QA:               return "http://172.16.204.251:9080"
        case .Development:      return "http://172.16.204.118:9195"
        case .Deloitte:         return "http://10.28.113.65:9080"
        case .UAT:              return "https://172.16.204.118:9195/AppVendedor"
        case .Custom:           return "\(self.customHostname)"
        }
    }
    
    private func isUAT(environment : Environment, customHostName : String) -> Bool {
        return  (environment == .Custom && customHostname == "https://172.16.204.118:9195/AppVendedor")
    }
    
    private let worklightRuntimeEnvironment = "/invoke?"
    
    private enum Adapter: String {
        case CapturaClientesCredito = "CapturaClientesCredito"
        case CatalogosCredito = "CatalogosCredito"
        case CICS = "Cicstran"
        case DEM = "DEM"
        case Genericos = "SKUGenerico"
        case Inventario = "SKUInventario"
        //*** This should be temporary until SOMSConsultaA Adapter is merged with SOMSConsultaNA. For more information see LSAA-1413 or ask Carazo.
        case ConsultaPool = "SOMSConsultaN"
        //***
        case SOMSRefund  = "SOMSDevoluciones"
        case ActualizacionPool = "SOMSActualizacionN"
        case BridgeCore = "LiverpoolWebService"
        case Details = "ProductDetailMashup"
        case Browse = "CatalogSearchBrowse"
        case Lookahead = "LookAheadService"
        case Endeca = "EndecaSearchServiceREST"
        case Catalog = "ProductCatalogActor"
        case CustomerSurvey = "EncuestasWS"
        case ShoeInventory = "SolicitudArticulosBodegaWebService"
        case Email = "EmailService"
        case SSO = "SSOWebService"
        case ShoppingList = "ShoppingListPag"
        case Configuration = "Configuraciones"
        case NoSpot = "Catalogos"
        case Shipment = "Remisiones"
        case CustomerInfo = "ConsultaDatosCliente"
        case MDMWebService = "MDMWebService"
        case ArchivosWS = "ArchivosWebService"
        case ReporteVentas = "ReporteVentas"
        
    }
    
    private enum Procedure: String {
        //CapturaClientesCredito
        case Login = "CapturaClientesCreditoService_Login"
        case SetSolicitudCredito = "CapturaClientesCreditoService_setSolicitudCredito"
        case subirArchivo = "CapturaClientesCreditoService_subirArchivo"
        
        //CatalogosCredito
        case CatAntigDom = "catAntigDom"
        case CatAntigEmp = "catAntigEmp"
        case CatLADA = "catLADA"
        case CatEstados = "catEstados"
        case CatOrgTipoTarj = "catOrgTipoTarj"
        
        //CICS
        case SegmentedCardBalance = "CicsRequestService_saldoSegmento"
        case CardBalance = "CicsRequestService_saldoCredito"
        case MonederoBalance = "CicsRequestService_saldoMonedero"
        
        // SOMS
        case ConsultaEMA = "DEMograficos_ConsultaEMA"
        case ConsultaCalle = "DEMograficos_ConsultaCalleCP"
        case ConsultaEdo = "DEMograficos_ConsultaEdo"
        case ConsultaMun = "DEMograficos_ConsultaMun"
        case ConsultaAsent = "DEMograficos_ConsultaAsent"
        case SOMSLogin = "SOMSActualizacionPoolService_getLoginPool"
        case GetCustomers = "SOMSConsultaPoolService_getConsultaClientesListaPool"
        case GetAddresses = "SOMSConsultaPoolService_getConsultaClientesDireccionesListaPool"
        case CreateAddress = "SOMSActualizacionPoolService_setAltaDireccion"
        case CreateCustomer = "SOMSActualizacionPoolService_setAltaCliente"
        case CreateOrder = "SOMSActualizacionPoolService_setAltaOrden"
        case CreateOrderWithSKUs = "SOMSActualizacionPoolService_setAltaOrdenListaSkus"
        case ModifyOrder = "SOMSActualizacionPoolService_setModificaOrden"
        case AppendSku = "SOMSActualizacionPoolService_setAgregaSKU"
        case SOMSDetails = "SOMSConsultaPoolService_getConsultaSKUPool"
        case AvailableToShip = "productAvailableToShip"
        case CreateRefundOrder = "NotificacionDevoluciones_CrearOrdenDevBT"
        case ModifyOrderAddress = "SOMSActualizacionPoolService_setModificaOrdenDireccion"
        
        // Endeca
        case ProductDetails = "getProductDetail"
        case CatalogBrowse = "getCatalogSearch"
        case Lookahead = "LookAheadProcedure"
        case AllCategoryInfo = "searchAllCategoryInfo"
        case ChildCategories = "getChildCategories"
        
        // Inventario
        case SkuInventario = "SKUINVENTARIO_ConsultaSku_Inventario"
        
        // Genericos
        case SkuGenericos = "SKUGENERICOS_ConsultaSku_Genericos"
        
        // Customer survey
        case Submit = "RegistrarEncuesta"
        case GetQuestions = "ConsultarDetalleEncuesta"
        case GetSurveyId = "BuscarEncuesta"
        
        // Shoe Inventory
        case RegisterTerminalForRemoteNotifications = "registrarTerminal"
        case CreateShoesOrder = "generarSolicitud"
        case UpdateShoesOrder = "actualizarEstado"
        case GetShoesOrders = "obtenerSolicitudes"
        
        // Email
        case SendEmail = "sendEmailWithAttachments"
        
        // SSO
        case ValidateToken = "credencialValida"
        
        //Persistent Shopping List
        case InsertClient = "insertarCliente"
        case EraseClient = "borrarCliente"
        case SearchClients = "buscarClientes"
        case SearchClient = "buscarCliente"
        case SearchClientData = "buscarDatosCliente"
        case AddSku = "agregarSku"
        case RemoveSku = "quitarSku"
        
        // Configuration
        case GetEmployeeSections = "ObtenerSeccionesEmpleado"
        case GetATGSectionsFromSAP = "ObtenerSeccionGrupoATG"
        case GetParameter = "consultarParametro"
        
        //No Spot
        case NoSpotSections = "ValidarSeccionNoSpot"
        case ValidNoSpotSections = "ListaSeccionesNoSpot"
        case SearchStoresCC = "obtenerTiendasCCPorEstado"
        case ConsultarEstadosTiendasCC = "consultarEstadosTiendasCC"
        case ObtenerDatosTienda = "obtenerDatosTienda"
        
        //No Spot Gift Registry
        case GiftRegistryTypes          = "obtenerTiposMesa"
        case GiftRegistryList           = "CicsRequestService_listaEvento"
        case GiftRegistrySearch         = "CicsRequestService_busquedaEvento"
        
        // Shipment
        case CreateUpdateSOMSShipmentSterling   = "Remisiones_wbi_CrearActualizarOVREMSterling"
        case CreateUpdateSOMSShipment           = "Remisiones_wbi_CreaActualizaOVREM"
        case CreateShipment                     = "Remisiones_wbi_CrearOrden"
        case UpdateShipment                     = "Remisiones_wbi_ActualizaRemision"
        case CreateUpdateCC                     = "Remisiones_wbi_CrearActualizarOVREMCC"
        
        // Order Follow Up
        case GetOrderDetail             = "Remisiones_wbi_consulta_orden"
        case UpdateDateCommentOrder     = "Remisiones_wbi_ActualizarOBS_FechaEntregaBT"
        
        
        // Shopping list
        case SearchAddressCustomer      = "DatosCliente_BuscarDireccionCliente"
        case SearchCustomer             = "DatosCliente_BusquedaCliente"
        
        //CRM Integration
        case CRMGetClientInfo = "obtenerDatosCliente"
        case CRMSaveClientEmail = "agregarEmail"
        
        //SurveyImageRequest
        case SurveyImageRequest = "obtenerArchivo"
        case InsertarRegistro = "insertarRegistro"
        
        // Check if product is "saleable"
        case ValidSaleExtendedCatalog = "isValidToSaleByExtendedCatalog"
        
    }
    
    //1 - WL up
    // 2 - WL Down
    static var currentWLStatus = "1"
    
    //Test setAgregaSKU Timeout
    var testSetAgregaSKUTimeout = false
    
    // MARK: - Initializers
    
    public init(environment: Environment = .Production, customHostname: String = "", shouldIgnoreSSL : Bool = false)
    {
        SessionManager.default.session.configuration.timeoutIntervalForRequest = 500
        
        self.environment = environment
        
        self.customHostname = customHostname
        
        if isUAT(environment: self.environment, customHostName: self.customHostname) && shouldIgnoreSSL == true {
            ignoreSSL()
        }
        
        self.manager.session.configuration.httpAdditionalHeaders = self.defaultHeaders()
        self.manager.session.configuration.timeoutIntervalForRequest = 60
    }

    public func ignoreSSL() {
        
        self.manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!) //(forTrust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = self.manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            
            return (disposition, credential)
        }
        
    }
    
    // MARK: - Helper Methods
    
    private func getRequestUrlForAdapter(adapter: Adapter, procedure: Procedure, parameters: AnyObject, isArray:Bool = false) -> String
    {
        let encodedParameters = worklightEncodedParameterDictionary(parameters: parameters, isArray: isArray)
        return self.customHostname + self.worklightRuntimeEnvironment + "adapter=\(adapter.rawValue)&" + "procedure=\(procedure.rawValue)&" + "compressResponse=true&" + "parameters=\(encodedParameters)"
    }
    
    
    private func worklightEncodedParameterDictionary(parameters: AnyObject , isArray: Bool = false) -> String
    {
        var data:NSData!
        do {
            data = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions()) as NSData
        }
        catch {
            return ""
        }
        var jsonString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)!
        jsonString = jsonString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! as NSString

        // BEFORE
        //jsonString = jsonString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        
        
        //There must be a better way to handle the URL expecting a plus sign to be encoded, even when a string value
        jsonString = jsonString.replacingOccurrences(of: "+", with: "%2B") as NSString
        //Need to wrap the JSON in [] for the worklight server
        if !isArray {
            jsonString = "[\(jsonString)]" as NSString
        }
        return jsonString as String
    }

    // MARK: - Helpers
    
    private func defaultHeaders() -> Dictionary<String, AnyObject>{
        
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let systemVersion = UIDevice.current.systemVersion
        let deviceModel = UIDevice.current.model
        
        let headers = [
            //"x-wl-clientlog-deviceId": UIDevice.currentDevice().identifierForVendor!.UUIDString,
            "x-wl-clientlog-appname": "AppVendedor",
            "x-wl-clientlog-appversion":  "\(appVersion) (\(buildNumber))",
            "x-wl-clientlog-osversion": systemVersion,
            "x-wl-clientlog-env": "mobilewebapp",
            "x-wl-clientlog-model": deviceModel
        ]
        return headers as Dictionary<String, AnyObject>
        
    }

    
    public func addressesForCustomerWithLada(userId: String, token: String, lada: String, telefono: String, cteTelefono: String, selectRecord: String, trySingleAddress: Bool) {
        
    }
    public func addShoppingSku(sku: String, storeNumber store: String, clientName: String, id: String, idTipoSku: String, createdAt: String) {
        
    }
    public func addSKUAndQuantityToSOMSOrder(userId: String, token: String, sku: String, quantity: String, orderNumber: String, noSpotSku: String?, noSpotQuantity: String?) {
        
    }
    public func allEstados() {
        
    }
    public func applyForCard(inApMaterno: String, inApPaterno: String, inClavePromotoria: String, inColorTarjeta: String, inEdad: Int, inEmpleadoPromotor: String, inFechaNacimiento: String, inFuenteCaptacion: String, inNombre: String, inNumFolio: String, inSexo: String, inTiendaAdmon: String, inTiendaCaptura: String, inAntiguadadDom: String, inCalleyNum: String, inCiudadMun: String, inColonia: String, inCP: String, inEdo: String, inEdoCivil: String, inEmpresaNegocio: String, inLadaDom: String, inNumDependientes: String, inPuestoDepto: String, inTelCel: String, inTelDom: String, inTipoVivienda: String, inAntiguedadEmp: String, inEmbosado: String, inIngresosTot: String, inLadaOfi: String, inTelOfi: String, inOrganization: String, inType: String, inPassword: String, inUser: String, vAmbiente: String) {
        
    }
    public func asensInEstadoWithId(estadoId: String, municipleId: String) {
        
    }
    public func bigTicketAvailableToShipWithSku(userId: String, token: String, sku: String, zip: String) {
        
    }
    public func callesCP(zip: String) {
        
    }
    public func callesInAsen(asen: String) {
        
    }
    public func cancelSurveyInProgress(surveyId: String, storeId: String, sectionId: String, employeeId: String, employeeName: String, ticketNumber: String, storeZone: String, storeAbbreviation: String) {
        
    }
    public func catAntigDom() {
        
    }
    public func catAntigEmp() {
        
    }
    public func catEstados() {
        
    }
    public func catLADA() {
        
    }
    public func catOrgTipoTarjeta(product: String, subProduct: String) {
        
    }
    public func changeDeliveryDateOfSKUOnSOMSOrder(userId: String, token: String, orderNumber: String, sku: String, date: String, originalDateString: String) {
        
    }
    public func changeSKUToClienteAvisaOnSOMSOrder(userId: String, token: String, orderNumber: String, sku: String) {
        
    }
    public func coloniasInZip(zip: String) {
        
    }
    public func createAddress(userId: String, token: String, isNewStreet: Bool, zip: String, calle: String, numeroExterior: String, selectRecordAsen: String, selectRecordCliente: String, tipoAsen: String, lada: String, telefono: String, betweenStreet: String?, andStreet: String?, interiorNumber: String?, edificio: String?) {
        
    }
    public func createCCOrder(lada: String, phone: String, name: String, userId: String, token: String, products: [WorklightShippingProduct]?, storeNumber: String, storeNumberToSend: String, orderNumber: String, isNewCustomer: Bool, isBigTicketOrder: Bool, email: String?) {
        
    }
    public func createCustomer(userId: String, token: String, isNewStreet: Bool, lada: String, telefono: String, paterno: String, firstName: String, zip: String, exteriorNumber: String, calle: String, selectRecordAsen: String, tipoAsen: String, materno: String?, rfc: String?, comment: String?, email: String?, betweenStreet: String?, andStreet: String?, interiorNumber: String?, edificio: String?) {
        
    }
    public func createShipmentOrder(orderID: String, storeNumber: String, customerFirstName: String, customerLastName: String, products: [WorklightShippingProduct]?, shippingAdress: WorklightShippingAddress) {
        
    }
    public func createShoesOrder(terminalId: Int, products: [Dictionary<String, AnyObject>]) {
        
    }
    public func createShoppingClient(name: String, email: String?, storeNumber store: String, idVendedor: String, fechaRegistro: String, skuList: [[String : String]], imageStringData: String?) {
        
    }
    public func createSOMSOrder(userId: String, token: String, firstProductSku: String, firstProductQuantity: String, firstProductNoSpotSku: String?, firstProductNoSpotQuantity: String?, lada: String?, telefono: String?, fldTelefono: String?, selectRecordCliente: String?, selectRecordSku: String, selectRecordAsentamiento: String?, orderComment: String?, singleAddressCustomer: Bool, eventID: String?) {
        
    }
    public func createSOMSOrder(userId: String, token: String, lada: String, telefono: String, fldTelefono: String, selectRecordCliente: String?, selectRecordAsentamiento: String?, orderComment: String?, singleAddressCustomer: Bool, eventID: String?, products: [WorklightSOMSProduct]!) {
        
    }
    public func createSOMSOrderLight(userId: String, token: String, lada: String, telefono: String, fldTelefono: String, selectRecordCliente: String, selectRecordAsentamiento: String, orderComment: String?, singleAddressCustomer: Bool, eventID: String?, products: [WorklightSOMSProduct]!) {
        
    }
    public func createSOMSRefundOrder(deliveryOrder: String, comments: String, products: [[String : String]], username: String, validationString: String) {
        
    }
    public func createUpdateSOMSShipmentOrder(shipmentID: String, customerID: String, addressID: String, currentStoreInventory: Bool, eventID: String?, senderID: String?, senderAddressID: String?, celebratedType: String?, token: String, userId: String) {
        
    }
    public func createUpdateSOMSShipmentOrderSterling(orderID: String, orderType: String, storeNumber: String, customerFirstName: String, customerLastName: String, senderCustomerFirstName: String, senderCustomerLastName: String, products: [WorklightShippingProduct]?, shippingAdress: WorklightShippingAddress, shipmentID: String, customerID: String, addressID: String, currentStoreInventory: Bool, eventID: String?, senderID: String?, senderAddressID: String?, celebratedType: String?, typeEvent: String, token: String, userId: String) {
        
    }
    public func creditBalanceForAccount(accountNumber: String, pin: String) {
        
    }
    public func customerAddressByID(customerID: String, neighborhood: String, street: String) {
        
    }
    public func customerInfoByLada(lada: String, phone: String, name: String, isGiftRegistry: Bool) {
        
    }
    public func customersWithEvent(eventID: String, userId: String, token: String) {
        
    }
    public func customersWithLada(lada: String, telefono: String, userId: String, token: String) {
        
    }
    public func detailsForProductWithSku(sku: String, storeNumber: String, buscaProducto: Dictionary<String, AnyObject>, completion: @escaping (WorklightResponse?, NSError?) -> Void) {
        
        let requestParameters = ["ProductDetail" : ["sku" : sku, "almacenId" : storeNumber, "buscaProducto": buscaProducto]]
        let url = getRequestUrlForAdapter(adapter: .Details, procedure: .ProductDetails, parameters: requestParameters as AnyObject)
        
        _ = manager.request(url).responseWorklight { [weak self](response) in
            guard let weakSelf = self else { return }
            let (result, error) = weakSelf.parseWorklightResponse(response)
            DispatchQueue.main.async {
                
                completion(result, error)
            }
        }
        
    }
    public func eraseShoppingClient(clientId: String, storeNumber: String) {
        
    }
    public func getAllCategoryInfo(completion: @escaping (WorklightResponse?, NSError?) -> Void) {
                
        let url = self.getRequestUrlForAdapter(adapter: .Endeca, procedure: .AllCategoryInfo, parameters: Dictionary<String, Any>() as AnyObject)
        
        _ = manager.request(url).responseWorklight { [weak self](response) in
            guard let weakSelf = self else { return }
            let (result, error) = weakSelf.parseWorklightResponse(response)
            DispatchQueue.main.async {

                completion(result, error)
            }
        }
        
    }
    public func getChildCategories(categoryId: String) {
        
    }
    public func getCustomerEmail(userId: String, token: String, lada: String, telefono: String, cteTelefono: String, selectRecord: String, trySingleAddress: Bool) {
        
    }
    public func getLoginPool(username: String, password: String, userId: String, token: String) {
        
    }
    public func getQuestionsForSurveyId(id: String) {
        
    }
    public func getSectionsEligibleForNoSpot() {
        
    }
    public func getSectionsOfValidNoSpotSkus() {
        
    }
    public func getShoesOrders(terminalId: Int, isWarehouse: Bool) {
        
    }
    public func getStoreDetail(store: String) {
        
    }
    public func getSurveyId(paymentTypes: [Int]) {
        
    }
    public func inventoryDetailsForSOMSItemWithSku(userId: String, token: String, sku: String, zip: String) {
        
    }
    public func isValidToSaleByExtendedCatalog(sku: [String]) {
        
    }
    public func loginWithUsername(username: String, password: String, usernameToken: String, validationString: String, environmentVariable: String, completion: @escaping (WorklightResponse?, NSError?) -> Void) {
        
        let requestParameters: [String : Any] = ["Login" : ["LoginFilters" :
            ["inUser" : username,
             "inPassword" : password,
             "inUsuario": usernameToken,
             "inCadenaValidacion" : validationString],
                                            "ModelVariables" : ["vAmbiente" : environmentVariable]]]
        let url = self.getRequestUrlForAdapter(adapter: .CapturaClientesCredito, procedure: .Login, parameters: requestParameters as AnyObject)
        
        _ = self.manager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseWorklight { [weak self] response in
        
            guard let weakSelf = self else { return }
            let (result, error) = weakSelf.parseWorklightResponse(response)
            DispatchQueue.main.async {
                
                completion(result, error)
            }
        }
        
    }
    public func lookAheadSuggestionsForKeyword(keyword: String) {
        
    }
    public func monederoBalanceForAccount(accountNumber: String) {
        
    }
    public func municiplesInEstadoWithId(estadoId: String) {
        
    }
    public func orderFollowUpGetOrderDetail(orderNumber: String, completion: @escaping (_ response: WorklightResponse?, _ error: NSError?) -> Void) {
        
        let params = [
            "consulta_ordenRequest" : [
                "IndicadorConsulta" : (orderNumber.hasPrefix("90") ? "OV" : "RM"),
                "OrdenEntrega_Remision" : orderNumber
            ]
        ]
        
        let url = getRequestUrlForAdapter(adapter: .Shipment, procedure: .GetOrderDetail, parameters: params as AnyObject)
        
        _ = manager.request(url).responseWorklight { [weak self](response) in
            guard let weakSelf = self else { return }
            let (result, error) = weakSelf.parseWorklightResponse(response)
            DispatchQueue.main.async {
                completion(result, error)
            }
        }
        
    }
    public func orderFollowUpUpdateDeliveryDate(orderNumber: String, sku: String?, date: String?, comments: String?, token: String, userId: String, completion: @escaping (_ response: WorklightResponse?, _ error: NSError?) -> Void) {
        
        
        let params = [
            "ActualizarOBS_FechaEntregaBTRequest" : [
                "FechaPropuesta"    : date ?? "",
                "IndicadorServicio" : (comments == nil ? "FEC" : "OBS"),
                "IndicadorTipo"     : (orderNumber.hasPrefix("90") ? "OV" : "RM"),
                "Observaciones"     : comments ?? "",
                "OrdenEntrega"      : orderNumber,
                "SKU"               : sku ?? "",
                "Usuario"           : "",
                "inCadenaValidacion": token,
                "inUser"            : userId
            ]
        ]
        
        let url = getRequestUrlForAdapter(adapter: .Shipment, procedure: .UpdateDateCommentOrder, parameters: params as AnyObject)
        
        _ = manager.request(url).responseWorklight { [weak self](response) in
            guard let weakSelf = self else { return }
            let (result, error) = weakSelf.parseWorklightResponse(response)
            DispatchQueue.main.async {
                completion(result, error)
            }
        }
        
    }
    public func productsForCategoryId(categoryId: String, page: String?, facets: [String]?, storeNumber: String, completion: @escaping (WorklightResponse?, NSError?) -> Void) {
        
        var childParameters:[String:Any] = ["almacenId" : storeNumber, "categoryId" : categoryId]
        if let page = page {
            childParameters["page"] = page
        }
        if let facets = facets {
            childParameters["facets"] = facets
        }
        let requestParameters = ["CatalogSearch" : childParameters]
        
        let url = getRequestUrlForAdapter(adapter: .Browse, procedure: .CatalogBrowse, parameters: requestParameters as AnyObject)
        
        _ = manager.request(url).responseWorklight { [weak self](response) in
            guard let weakSelf = self else { return }
            let (result, error) = weakSelf.parseWorklightResponse(response)
            DispatchQueue.main.async {
                completion(result, error)
            }
        }
        
    }
    public func productsForKeyword(keyword: String, page: String?, facets: [String]?, storeNumber: String, completion: @escaping (WorklightResponse?, NSError?) -> Void) {
        
        let charset = NSCharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
        
        
        var childParameters:[String: Any] = ["almacenId" : storeNumber, "s" : keyword.addingPercentEncoding(withAllowedCharacters: charset) ?? ""]
        if let page = page {
            childParameters["page"] = page
        }
        if let facets = facets {
            childParameters["facets"] = facets
        }
        let requestParameters = ["CatalogSearch" : childParameters]
        let url = getRequestUrlForAdapter(adapter: .Browse, procedure: .CatalogBrowse, parameters: requestParameters as AnyObject)
        
        _ = manager.request(url).responseWorklight { [weak self](response) in
            guard let weakSelf = self else { return }
            let (result, error) = weakSelf.parseWorklightResponse(response)
            DispatchQueue.main.async {

                completion(result, error)
            }
        }
        
    }
    public func registerTerminalForRemoteNotificationsWithStoreId(storeId: String, sectionId: String, deviceId: String, employeeName: String?, idEmployee: Int, isWarehouse: Bool) {
        
    }
    public func removeShoppingSku(sku: String, id: String) {
        
    }
    public func requestSurveyImage(imageName: String, update: Bool) {
        
    }
    public func resetWLStatus() {
        
    }
    public func retrieveGiftRegistry(eventID: String, completion: @escaping (WorklightResponse?, NSError?) -> Void) {
        let params = [
            "TSCMES11": [
                "evento": eventID,
                "tipo": ""
            ]
        ]
        
        let url = getRequestUrlForAdapter(adapter: .CICS, procedure: .GiftRegistryList, parameters: params as AnyObject)
        
        _ = self.manager.request(url).responseWorklight { [weak self](response) in
            guard let weakSelf = self else{ return }
            let (result, error) = weakSelf.parseWorklightResponse(response)
            
            DispatchQueue.main.async {
                completion(result, error)
            }
        }
        
        
    }
    public func retrieveGiftRegistryTypes(completion: @escaping (WorklightResponse?, NSError?) -> Void) {
     
        let params = ["obtenerTiposMesaRequest": []]
        
        let url = getRequestUrlForAdapter(adapter: .NoSpot, procedure: .GiftRegistryTypes, parameters: params as AnyObject)
        
        _ = self.manager.request(url).responseWorklight { [weak self](response) in
            guard let weakSelf = self else{ return }
            let (result, error) = weakSelf.parseWorklightResponse(response)
            
            DispatchQueue.main.async {
                completion(result, error)
            }
            
        }

        
    }
    
    public func retrieveGiftRegistryWithApplicationType(eventID: String, appType: Bool, completion: @escaping (WorklightResponse?, NSError?) -> Void) {
        
        let params = [
            "TSCMES11": [
                "evento": eventID,
                "tipo": ""
            ]
        ]
        
        let url = getRequestUrlForAdapter(adapter: .CICS, procedure: .GiftRegistryList, parameters: params as AnyObject)
        
        _ = self.manager.request(url).responseWorklight { [weak self](response) in
            guard let weakSelf = self else{ return }
            let (result, error) = weakSelf.parseWorklightResponse(response)
            
            DispatchQueue.main.async {
                completion(result, error)
            }
            
        }
        
    }
    public func retrieveRestrictedSKUsForShipping() {
        
    }
    public func salesReport(items: AnyObject) {
        
    }
    public func searchCCStates() {
        
    }
    public func searchCCStores(state: String) {
        
    }
    public func searchGiftRegistry(name: String!, lastName: String!, secondLastName: String!, date: String!, type: NSNumber!, gender: String!, completion: @escaping (WorklightResponse?, NSError?) -> Void) {
        
        let params = [
            "TSCMES12": [
                "nombre": name ?? "",
                "paterno": lastName ?? "",
                "materno": secondLastName ?? "",
                "fechaDe": date ?? "",
                "tipo": type ?? 0,
                "sexo": gender ?? ""
            ]
        ]
        
        let url = getRequestUrlForAdapter(adapter: .CICS, procedure: .GiftRegistrySearch, parameters: params as AnyObject)
        
        _ = self.manager.request(url).responseWorklight { [weak self](response) in
            guard let weakSelf = self else{ return }
            let (result, error) = weakSelf.parseWorklightResponse(response)
            
            DispatchQueue.main.async {
                completion(result, error)
            }
            
        }
        
        
    }
    public func searchShoppingClient(clientId: String, storeNumber: String) {
        
    }
    public func searchShoppingClients(clientName: String, storeNumber: String, idVendedor: String, fechaInicio: String, fechaFin: String, email: String, page: String?, elementsPerPage: String?) {
        
    }
    public func segmentedCreditBalanceForAccount(accountNumber: String, pin: String) {
        
    }
    public func sendEmailTo(to: String, withTitle title: String, message: String, storeType: String, attachment: (fileName: String, mimeType: String, data: NSData)?) {
        
    }
    public func skuGenericosForSku(sku: String) {
        
    }
    public func skuInventarioWithSku(sku: String, completion: @escaping (WorklightResponse?, NSError?) -> Void) {
        
        let parameters = ["ConsultaSku_InventarioRequest" : ["Articulo" : sku]]
        let url = getRequestUrlForAdapter(adapter: .Inventario, procedure: .SkuInventario, parameters: parameters as AnyObject)
        
        _ = self.manager.request(url).responseWorklight { [weak self](response) in
            guard let weakSelf = self else{ return }
            let (result, error) = weakSelf.parseWorklightResponse(response)
            
            DispatchQueue.main.async {
                completion(result, error)
            }
        }
    }
    public func ssoTokenIsValid(token: String, systemID: String, userId: String) {
        
    }
    public func subirArchivo(imageStringData: String, aplicacion: String, numFolio: String, org: String, logo: String, almacen: String, nombre: String, apPaterno: String, apMaterno: String) {
        
    }
    public func submitSurveyResponses(responses: [AnyObject], surveyId: String, storeId: String, sectionId: String, employeeId: String, employeeName: String, ticketNumber: String, storeZone: String, storeAbbreviation: String) {
        
    }
    public func updateCustomerAddressSOMS(orderNumber: String, lada: String, telephone: String, inFldTelephone: String, clientRecord: String, inEvent: String, inEventCard: String, inCard: String, selectRecordAsen: String, eventLada: String, inTelephoneEvent: String, isMoreDir: String, inPassword: String, inUser: String, token: String) {
        
    }
    public func updateShoesOrder(requestId: Int, terminalId: Int, state: Int) {
        
    }
    
    /*
    func checkIfServiceDown(serviceError:NSError?)
    {
        if let err = serviceError
        {
            if ((err.code == 3840 && err.localizedDescription == "Servicio no disponible.") || (err.code == -1005) || (err.code == -1004)) && WorklightServiceProvider.currentWLStatus != "2"
            {
                WorklightServiceProvider.currentWLStatus = "2"
                //Post notification here
                NSNotificationCenter.defaultCenter().postNotificationName("WLStatusChanged", object: WorklightServiceProvider.currentWLStatus)
            }
        }
        else if WorklightServiceProvider.currentWLStatus == "2"
        {
            WorklightServiceProvider.currentWLStatus = "1"
            //Post notification here
            NSNotificationCenter.defaultCenter().postNotificationName("WLStatusChanged", object: WorklightServiceProvider.currentWLStatus)
        }
    }
    
    public func resetWLStatus()
    {
        WorklightServiceProvider.currentWLStatus = "1"
    }*/
    
    func parseWorklightResponse(_ response: DataResponse<Data>)->(WorklightResponse?, NSError?){
    
        if response.error != nil {
        
            return (nil, response.error! as NSError)
        }else{
        
            if let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? [String : Any]{
                
                if let wlResponse = WorklightResponse(JSON: json!){
                    return (wlResponse, nil)
                }else{
                    return (nil, NSError(domain: "worklight.object", code: WorklightErrorCodes.WLResponseParser.rawValue, userInfo: [NSLocalizedDescriptionKey : "No se pudo crear el objeto Worklight Response"]))
                }
                
            }else{
            
                return (nil, NSError(domain: "json.parser", code: WorklightErrorCodes.JSONParser.rawValue, userInfo: [NSLocalizedDescriptionKey : "La respuesta no viene en el formato correcto"]))
            }
            
        }
        

    }
    
    // MARK: - Remote Configuration Parameters
    
    public func getConfigurationParameter(name: String, completion: @escaping (WorklightResponse?, NSError?) -> Void)
    {
        let params = [
            "consultarParametroRequest" : [
                "nombre": name
            ]
        ]
        
        let url = getRequestUrlForAdapter(adapter: .NoSpot, procedure: .GetParameter, parameters: params as AnyObject)
        _ = self.manager.request(url).responseWorklight { [weak self](response) in
            guard let weakSelf = self else{ return }
            let (result, error) = weakSelf.parseWorklightResponse(response)
            
            DispatchQueue.main.async {
                completion(result, error)
            }
            
        }
    }
    
}

