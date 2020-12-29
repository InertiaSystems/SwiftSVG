import Foundation

final class SVGScript: SVGShapeElement {
    
    static var elementName: String = "script"
    
    var json:String? = ""

    var supportedAttributes: [String : (String) -> ()] = [:]
    
    internal func json(js: String) {
        guard let json = String?(js) else {
            return
        }
        self.json = json
    }
    
    internal var svgLayer = SVGLayer()

    
    func didProcessElement(in container: SVGContainerElement?) {
        guard let container = container else {
            return
        }
        self.svgLayer.data = self.json!
        self.svgLayer.icdObjType = SVGScript.elementName
        container.containerLayer.addSublayer( self.svgLayer)

    }
    
    
}
