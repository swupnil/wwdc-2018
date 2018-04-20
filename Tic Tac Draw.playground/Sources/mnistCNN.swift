//
// mnistCNN.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
public class mnistCNNInput : MLFeatureProvider {

    /// Grayscale image of hand written digit as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 28 pixels wide by 28 pixels high
    var image: CVPixelBuffer
    
    public var featureNames: Set<String> {
        get {
            return ["image"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "image") {
            return MLFeatureValue(pixelBuffer: image)
        }
        return nil
    }
    
    public init(image: CVPixelBuffer) {
        self.image = image
    }
}


/// Model Prediction Output Type
public class mnistCNNOutput : MLFeatureProvider {

    /// Predicted digit as dictionary of strings to doubles
    public let output: [String : Double]

    /// classLabel as string value
    public let classLabel: String
    
    public var featureNames: Set<String> {
        get {
            return ["output", "classLabel"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "output") {
            return try! MLFeatureValue(dictionary: output as [NSObject : NSNumber])
        }
        if (featureName == "classLabel") {
            return MLFeatureValue(string: classLabel)
        }
        return nil
    }
    
    init(output: [String : Double], classLabel: String) {
        self.output = output
        self.classLabel = classLabel
    }
}


/// Class for model loading and prediction
public class mnistCNN {
    var model: MLModel

    /**
        Construct a model with explicit path to mlmodel file
        - parameters:
           - url: the file url of the model
           - throws: an NSError object that describes the problem
    */
    public init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /// Construct a model that automatically loads the model from the app's bundle
    public convenience init() {
        let bundle = Bundle(for: mnistCNN.self)
        let assetPath = bundle.url(forResource: "mnistCNN", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as mnistCNNInput
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as mnistCNNOutput
    */
    public func prediction(input: mnistCNNInput) throws -> mnistCNNOutput {
        let outFeatures = try model.prediction(from: input)
        let result = mnistCNNOutput(output: outFeatures.featureValue(for: "output")!.dictionaryValue as! [String : Double], classLabel: outFeatures.featureValue(for: "classLabel")!.stringValue)
        return result
    }

    /**
        Make a prediction using the convenience interface
        - parameters:
            - image: Grayscale image of hand written digit as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 28 pixels wide by 28 pixels high
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as mnistCNNOutput
    */
    public func prediction(image: CVPixelBuffer) throws -> mnistCNNOutput {
        let input_ = mnistCNNInput(image: image)
        return try self.prediction(input: input_)
    }
}
