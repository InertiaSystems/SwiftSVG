import Foundation

// MARK: - WelcomeValue
public struct IcdItem : IIcdItem {
    let dataDBSurrogateKey, dataDBIcdModelFileID, dataDBElementID: Int?
    let dataDBName, dataDBSheetids, dataDBExternalID: String?
    let dataDBAttrs: DataDBAttrs?
    let dataDBID: Int?
    let dataDBCategory: String?
    public let id : String?
    
    
    enum CodingKeys: String , CodingKey {
        case dataDBSurrogateKey = "data-db-surrogate-key"
        case dataDBIcdModelFileID = "data-db-icd-model-file-id"
        case dataDBElementID = "data-db-element-id"
        case dataDBName = "data-db-name"
        case dataDBSheetids = "data-db-sheetids"
        case dataDBExternalID = "data-db-external-id"
        case dataDBID = "data-db-id"
        case dataDBAttrs = "data-db-attrs"
        case dataDBCategory = "data-db-category"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode firstName & lastName
        dataDBSurrogateKey = try container.decode(Int?.self, forKey: CodingKeys.dataDBSurrogateKey)
        dataDBIcdModelFileID = try container.decode(Int?.self, forKey: CodingKeys.dataDBIcdModelFileID)
        if container.contains(CodingKeys.dataDBElementID){
            dataDBElementID = try container.decode(Int?.self, forKey: CodingKeys.dataDBElementID)
        }else  {
            dataDBElementID = nil
        }
        if container.contains(CodingKeys.dataDBName){
            dataDBName = try container.decode(String?.self, forKey: CodingKeys.dataDBName)
        }else{
            dataDBName = nil
        }
        dataDBSheetids = try container.decode(String?.self, forKey: CodingKeys.dataDBSheetids)
        dataDBExternalID = try container.decode(String?.self, forKey: CodingKeys.dataDBExternalID)
        dataDBID = try container.decode(Int?.self, forKey: CodingKeys.dataDBID)
        
        dataDBAttrs = try container.decode(DataDBAttrs.self, forKey: CodingKeys.dataDBAttrs)
        if container.contains(CodingKeys.dataDBCategory){
            dataDBCategory = try container.decode(String?.self, forKey: CodingKeys.dataDBCategory)
        }else{
            dataDBCategory = nil
        }
        id = container.codingPath.first!.stringValue

    }
}

public protocol IIcdItem :  Decodable{
    var id : String? { get }
}


public struct DecodedArray<T: IIcdItem>: Decodable {

    public typealias DecodedArrayType = Dictionary<String,T>

    private var array: DecodedArrayType

    // Define DynamicCodingKeys type needed for creating decoding container from JSONDecoder
    private struct DynamicCodingKeys: CodingKey {

        // Use for string-keyed dictionary
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        // Use for integer-keyed dictionary
        var intValue: Int?
        init?(intValue: Int) {
            // We are not using this, thus just return nil
            return nil
        }
    }

    public init(from decoder: Decoder) throws {

        // Create decoding container using DynamicCodingKeys
        // The container will contain all the JSON first level key
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        var tempArray = DecodedArrayType()

        // Loop through each keys in container
        for key in container.allKeys {

            // Decode T using key & keep decoded T object in tempArray
            let decodedObject = try container.decode(T.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            if let id = decodedObject.id {
                tempArray[id] = decodedObject
            }
        }

        // Finish decoding all T objects. Thus assign tempArray to array.
        array = tempArray
    }
}

// Transform DecodedArray into custom collection
extension DecodedArray: Collection {

    // Required nested types, that tell Swift what our collection contains
    public  typealias Index = DecodedArrayType.Index
    public  typealias Element = DecodedArrayType.Element

    // The upper and lower bounds of the collection, used in iterations
    public var startIndex: Index { return array.startIndex }
    public var endIndex: Index { return array.endIndex }

    // Required subscript, based on a dictionary index
    public subscript(index: Index) -> Iterator.Element {
        get { return array[index] }
    }

    // Method that returns the next index when iterating
    public func index(after i: Index) -> Index {
        return array.index(after: i)
    }
}

// MARK: - DataDBAttrs
struct DataDBAttrs : Decodable{
    let id: String?
    let identityData: [String: [String]]?
    let phasing: Phasing?
    let constraints: [String: [String]]?
    let category: Category?
    let structural: Structural?
    let dimensions: [String: [String]]?
    let fireProtection: FireProtection?
    let categoryID: CategoryID?
    let viewableIn: ViewableIn?
    let parent: Parent?
    let name: Name?
    let instanceof: Instanceof?
    let internalref: Internalref?
    let graphics, other: [String: [String]]?
    let extents: Extents?
    let text: Text?
    let construction: Construction?
    let materialsAndFinishes: MaterialsAndFinishes?
    let data: DataClass?
    let electricalLoads: ElectricalLoads?
    let mechanical: Mechanical?
    let electricalCircuiting: ElectricalCircuiting?
    let electricalLighting: ElectricalLighting?
    let child: Child?
    

}

// MARK: - Category
struct Category : Decodable{
    let category: [String]?
}



// MARK: - CategoryID
struct CategoryID : Decodable{
    let categoryID: [String]?
}

// MARK: - Child
struct Child : Decodable{
    let child: [String]?
}

// MARK: - Construction
struct Construction : Decodable {
    let revisionID, frameType, revisionDescription, frameDetailHead: [String]?
    let frameDetailJamb, frameDetailSill, showValence: [String]?
}

// MARK: - DataClass
struct DataClass : Decodable{
    let wallDepth, frameDepth: [String]?
}

// MARK: - ElectricalCircuiting
struct ElectricalCircuiting : Decodable{
    let electricalData: [String]?
}

// MARK: - ElectricalLighting
struct ElectricalLighting : Decodable{
    let calculateCoefficientOfUtilization, coefficientOfUtilization, switchID: [String]?
}

// MARK: - ElectricalLoads
struct ElectricalLoads : Decodable{
    let panel, circuitNumber, emergency: [String]?
}

// MARK: - Extents
struct Extents : Decodable{
    let cropRegionVisible, scopeBox, depthClipping, cropView: [String]?
    let viewRange, associatedLevel, annotationCrop: [String]?
}

// MARK: - FireProtection
struct FireProtection : Decodable{
    let fireRatingNBBJ: [FireRatingNBBJ]?
}

enum FireRatingNBBJ : Decodable{
    init(from decoder: Decoder) throws {
        try self.init(from: decoder)
    }
    

    
    case empty
    case the20Min
    case the45Min
    case the90Min
}

// MARK: - Instanceof
struct Instanceof : Decodable{
    let instanceofObjid: [String]?
}

// MARK: - Internalref
struct Internalref : Decodable{
    let level, group, hostFamily, subFamily: [String]?
}

// MARK: - MaterialsAndFinishes
struct MaterialsAndFinishes : Decodable{
    let materialsAndFinishesFrameMaterial: [FrameMaterial]?
    let panelMaterial: [PanelMaterial]?
    let panelMaterialFinish, frameMaterialFinish: [FrameMaterialFinish]?
    let frameMaterial: [String]?
    let finish: [Finish]?
    let panelGlazingMaterial: [FrameMaterialFinish]?
}

enum Finish : Decodable{
    init(from decoder: Decoder) throws {
        try self.init(from: decoder)
    }
    
    case empty
    case plam9
    case pnt
}

enum FrameMaterialFinish : Decodable{
    init(from decoder: Decoder) throws {
        try self.init(from: decoder)
    }
    
    case byCategory
}

enum FrameMaterial : Decodable{
    init(from decoder: Decoder) throws {
        try self.init(from: decoder)
    }
    
    case al
    case empty
    case hmPnt
}

enum PanelMaterial : Decodable{
    init(from decoder: Decoder) throws {
        try self.init(from: decoder)
    }
    
    case empty
    case hm
    case wood
}

// MARK: - Mechanical
struct Mechanical : Decodable{
    let systemAbbreviation, systemType, systemClassification, systemName: [String]?
}

// MARK: - Name
struct Name : Decodable{
    let name: [String]?
}

// MARK: - Parent
struct Parent : Decodable{
    let parent: [String]?
}

// MARK: - Phasing
struct Phasing : Decodable{
    let phaseCreated: [Phase]?
    let phaseDemolished: [PhaseDemolished]?
    let phaseFilter: [String]?
    let phase: [Phase]?
}

enum Phase : Decodable{
    init(from decoder: Decoder) throws {
        try self.init(from: decoder)
    }
    
    case newConstruction
}

enum PhaseDemolished : Decodable{
    init(from decoder: Decoder) throws {
        try self.init(from: decoder)
    }
    
    case none
}

// MARK: - Structural
struct Structural : Decodable{
    let structuralUsage: [StructuralUsage]?
    let structural, enableAnalyticalModel, rebarCover: [String]?
}

enum StructuralUsage : Decodable {
    init(from decoder: Decoder) throws {
        try self.init(from: decoder)
    }
    
    case nonBearing
}

// MARK: - Text
struct Text : Decodable{
    let glassType: [String]?
}

// MARK: - ViewableIn
struct ViewableIn : Decodable{
    let viewableIn: [ViewableInElement]?
}

enum ViewableInElement : Decodable{
    init(from decoder: Decoder) throws {
        try self.init(from: decoder)
    }

}
