import SwiftUI
import ARKit
import RealityKit
import Lottie

// Main AR View with Controls
struct ARViewWithControls: View {
    @State private var resetModel = false
    @State private var modelScale: Float = 0.5 // Set the initial model scale
    private let modelName = "sample"

    var body: some View {
        ZStack {
            ARViewContainer(modelName: modelName, reset: $resetModel, initialScale: modelScale)
                .edgesIgnoringSafeArea(.all)
            HUDOverlay(
                resetPosition: {
                    NotificationCenter.default.post(name: .resetPosition, object: nil)
                },
                resetScale: {
                    NotificationCenter.default.post(name: .resetScale, object: nil)
                },
                resetRotation: {
                    NotificationCenter.default.post(name: .resetRotation, object: nil)
                },
                zoomIn: {
                    modelScale = min(modelScale * 1.1, 2.0) // Zoom in, cap at 2.0
                    NotificationCenter.default.post(name: .updateScale, object: modelScale)
                },
                zoomOut: {
                    modelScale = max(modelScale * 0.9, 0.1) // Zoom out, cap at 0.1
                    NotificationCenter.default.post(name: .updateScale, object: modelScale)
                }
            )
        }
    }
}

// ARViewContainer - UIViewRepresentable for AR View
struct ARViewContainer: UIViewRepresentable {
    var modelName: String
    @Binding var reset: Bool
    var initialScale: Float
    var animationView = LottieAnimationView(name: "ar") // Initialize with your Lottie file name

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView(frame: .zero)
        
        // ARView Setup
        let arView = ARView(frame: .zero)
        arView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(arView)
        
        NSLayoutConstraint.activate([
            arView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            arView.topAnchor.constraint(equalTo: containerView.topAnchor),
            arView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // Configure AR session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        
        // Load the 3D model initially
        context.coordinator.loadModel(name: modelName, in: arView, initialScale: initialScale)
        
        // Add gesture recognizers
        arView.addGestureRecognizer(UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePanGesture(_:))))
        arView.addGestureRecognizer(UIRotationGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleRotationGesture(_:))))
        arView.addGestureRecognizer(UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinchGesture(_:))))
        
        // Add Lottie Animation View
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = .loop
        animationView.play()
        containerView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 150),
            animationView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // Add Directional Light
        addDirectionalLight(to: arView)
        
        // Visualize Detected Planes
        visualizeDetectedPlanes(arView: arView)
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if reset {
            if let arView = uiView.subviews.compactMap({ $0 as? ARView }).first {
                context.coordinator.resetModel(in: arView)
                DispatchQueue.main.async {
                    reset = false
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(modelName: modelName)
    }
    
    func visualizeDetectedPlanes(arView: ARView) {
        arView.debugOptions = [.showFeaturePoints, .showAnchorGeometry]
    }
    
    func addDirectionalLight(to arView: ARView) {
        let lightEntity = Entity()
        var lightComponent = DirectionalLightComponent()
        lightComponent.color = .white
        lightComponent.intensity = 3000
        lightEntity.components[DirectionalLightComponent.self] = lightComponent
        
        // Anchor the light in the scene
        let lightAnchor = AnchorEntity(world: [0, 1, 0]) // Position the light above the model
        lightAnchor.addChild(lightEntity)
        arView.scene.addAnchor(lightAnchor)
    }
}

// Coordinator with reset functions and gesture handling
class Coordinator: NSObject {
    var modelEntity: ModelEntity?
    var modelAnchor: AnchorEntity?
    var modelName: String

    init(modelName: String) {
        self.modelName = modelName
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleResetPosition), name: .resetPosition, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleResetScale), name: .resetScale, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleResetRotation), name: .resetRotation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateScale(_:)), name: .updateScale, object: nil)
    }

    func loadModel(name: String, in arView: ARView, initialScale: Float) {
        do {
            modelEntity = try ModelEntity.loadModel(named: name)
            modelEntity?.scale = SIMD3<Float>(repeating: initialScale) // Set initial scale
            modelAnchor = AnchorEntity(plane: .horizontal)
            
            if let modelEntity = modelEntity, let modelAnchor = modelAnchor {
                modelAnchor.addChild(modelEntity)
                arView.scene.addAnchor(modelAnchor)
            }
        } catch {
            print("Failed to load model: \(error.localizedDescription)")
        }
    }

    func resetModel(in arView: ARView) {
        // Reset position, scale, and rotation together
        resetPosition()
        resetScale()
        resetRotation()
    }

    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let modelEntity = modelEntity else { return }
        let translation = gesture.translation(in: gesture.view)
        let position = modelEntity.position
        modelEntity.position = [position.x + Float(translation.x) * 0.001, position.y, position.z - Float(translation.y) * 0.001]
        gesture.setTranslation(.zero, in: gesture.view)
    }
    
    @objc func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        guard let modelEntity = modelEntity else { return }
        if gesture.state == .changed {
            let rotation = simd_float3(0, Float(gesture.rotation), 0)
            modelEntity.orientation *= simd_quatf(angle: rotation.y, axis: [0, 1, 0])
            gesture.rotation = 0
        }
    }
    
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let modelEntity = modelEntity else { return }
        if gesture.state == .changed {
            let scale = gesture.scale
            let newScale = max(0.1, min(2.0, modelEntity.scale.x * Float(scale))) // Scale limits between 0.1 and 2.0
            modelEntity.scale = SIMD3<Float>(repeating: newScale)
            gesture.scale = 1
            NotificationCenter.default.post(name: .updateScale, object: newScale)
        }
    }

    @objc func handleResetPosition() {
        resetPosition()
    }

    @objc func handleResetScale() {
        resetScale()
    }

    @objc func handleResetRotation() {
        resetRotation()
    }

    @objc func handleUpdateScale(_ notification: Notification) {
        if let scale = notification.object as? Float {
            modelEntity?.scale = SIMD3<Float>(repeating: scale)
        }
    }

    func resetPosition() {
        guard let modelEntity = modelEntity else { return }
        modelEntity.transform.translation = SIMD3<Float>(0, 0, 0)
    }

    func resetScale() {
        guard let modelEntity = modelEntity else { return }
        modelEntity.scale = SIMD3<Float>(repeating: 0.5) // Reset scale to 0.5
    }

    func resetRotation() {
        guard let modelEntity = modelEntity else { return }
        modelEntity.transform.rotation = simd_quatf(angle: 0, axis: [0, 1, 0])
    }
}

// HUDOverlay for control buttons
struct HUDOverlay: View {
    var resetPosition: () -> Void
    var resetScale: () -> Void
    var resetRotation: () -> Void
    var zoomIn: () -> Void
    var zoomOut: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: resetPosition) {
                    Text("Reset Position")
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: resetScale) {
                    Text("Reset Scale")
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: resetRotation) {
                    Text("Reset Rotation")
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: zoomIn) {
                    Text("Zoom In")
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: zoomOut) {
                    Text("Zoom Out")
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

// Notification Names for Reset Actions
extension Notification.Name {
    static let resetPosition = Notification.Name("resetPosition")
    static let resetScale = Notification.Name("resetScale")
    static let resetRotation = Notification.Name("resetRotation")
    static let updateScale = Notification.Name("updateScale")
}
