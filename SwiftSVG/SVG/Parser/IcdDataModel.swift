import Foundation

// MARK: - IcdItem
public struct IcdItem : IIcdItem {
    public let dataDBSurrogateKey, dataDBIcdModelFileID, dataDBElementID: Int?
    public let dataDBName, dataDBSheetids, dataDBExternalID: String?
    public let dataDBAttrs: DataDBAttrs?
    public let dataDBID: Int?
    public let dataDBCategory: String?
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
public struct DataDBAttrs : Decodable{
    public let id: String?
    public let identityData: [String: [String]]?
    public let phasing: Phasing?
    public let constraints: [String: [String]]?
    public let category: Category?
    public let structural: Structural?
    public let dimensions: [String: [String]]?
    public let fireProtection: FireProtection?
    public let categoryID: CategoryID?
    public let viewableIn: ViewableIn?
    public let parent: Parent?
    public let name: Name?
    public let instanceof: Instanceof?
    public let internalref: Internalref?
    public let graphics, other: [String: [String]]?
    public let extents: Extents?
    public let text: Text?
    public let construction: Construction?
    public let materialsAndFinishes: MaterialsAndFinishes?
    public let data: DataClass?
    public let electricalLoads: ElectricalLoads?
    public let mechanical: Mechanical?
    public let electricalCircuiting: ElectricalCircuiting?
    public let electricalLighting: ElectricalLighting?
    public let child: Child?
    

}

// MARK: - Category
public struct Category : Decodable{
    let category: [String]?
}



// MARK: - CategoryID
public struct CategoryID : Decodable{
    let categoryID: [String]?
}

// MARK: - Child
public struct Child : Decodable{
    let child: [String]?
}

// MARK: - Construction
public struct Construction : Decodable {
    let revisionID, frameType, revisionDescription, frameDetailHead: [String]?
    let frameDetailJamb, frameDetailSill, showValence: [String]?
}

// MARK: - DataClass
public struct DataClass : Decodable{
    let wallDepth, frameDepth: [String]?
}

// MARK: - ElectricalCircuiting
public struct ElectricalCircuiting : Decodable{
    let electricalData: [String]?
}

// MARK: - ElectricalLighting
public struct ElectricalLighting : Decodable{
    let calculateCoefficientOfUtilization, coefficientOfUtilization, switchID: [String]?
}

// MARK: - ElectricalLoads
public struct ElectricalLoads : Decodable{
    let panel, circuitNumber, emergency: [String]?
}

// MARK: - Extents
public struct Extents : Decodable{
    let cropRegionVisible, scopeBox, depthClipping, cropView: [String]?
    let viewRange, associatedLevel, annotationCrop: [String]?
}

// MARK: - FireProtection
public struct FireProtection : Decodable{
    let fireRatingNBBJ: [FireRatingNBBJ]?
}

public enum FireRatingNBBJ : Decodable{
    public init(from decoder: Decoder) throws {
        try self.init(from: decoder)
    }
    

    
    case empty
    case the20Min
    case the45Min
    case the90Min
}

// MARK: - Instanceof
public struct Instanceof : Decodable{
    let instanceofObjid: [String]?
}

// MARK: - Internalref
public struct Internalref : Decodable{
    let level, group, hostFamily, subFamily: [String]?
}

// MARK: - MaterialsAndFinishes
public struct MaterialsAndFinishes : Decodable{
    let materialsAndFinishesFrameMaterial: [FrameMaterial]?
    let panelMaterial: [PanelMaterial]?
    let panelMaterialFinish, frameMaterialFinish: [FrameMaterialFinish]?
    let frameMaterial: [String]?
    let finish: [Finish]?
    let panelGlazingMaterial: [FrameMaterialFinish]?
}

public enum Finish : Decodable{
    public init(from decoder: Decoder) throws {
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

public enum PanelMaterial : Decodable{
    public init(from decoder: Decoder) throws {
        try self.init(from: decoder)
    }
    
    case empty
    case hm
    case wood
}

// MARK: - Mechanical
public struct Mechanical : Decodable{
    let systemAbbreviation, systemType, systemClassification, systemName: [String]?
}

// MARK: - Name
public struct Name : Decodable{
    let name: [String]?
}

// MARK: - Parent
public struct Parent : Decodable{
    let parent: [String]?
}

// MARK: - Phasing
public struct Phasing : Decodable{
    let phaseCreated: [Phase]?
    let phaseDemolished: [PhaseDemolished]?
    let phaseFilter: [String]?
    let phase: [Phase]?
}

public enum Phase : Decodable{
    public init(from decoder: Decoder) throws {
        try self.init(from: decoder)
    }
    
    case newConstruction
}

public enum PhaseDemolished : Decodable{
    public init(from decoder: Decoder) throws {
        try self.init(from: decoder)
    }
    
    case none
}

// MARK: - Structural
public struct Structural : Decodable{
    let structuralUsage: [StructuralUsage]?
    let structural, enableAnalyticalModel, rebarCover: [String]?
}

public enum StructuralUsage : Decodable {
    public init(from decoder: Decoder) throws {
        try self.init(from: decoder)
    }
    
    case nonBearing
}

// MARK: - Text
public struct Text : Decodable{
    let glassType: [String]?
}

// MARK: - ViewableIn
public struct ViewableIn : Decodable{
    let viewableIn: [ViewableInElement]?
}

public enum ViewableInElement : Decodable{
    public init(from decoder: Decoder) throws {
        try self.init(from: decoder)
    }

}
