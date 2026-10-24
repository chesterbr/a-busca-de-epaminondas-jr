import Foundation
import Vision
import AppKit
// uso: ocr imagem.png  -> imprime as linhas reconhecidas (de cima para baixo)
let url = URL(fileURLWithPath: CommandLine.arguments[1])
guard let img = NSImage(contentsOf: url), let cg = img.cgImage(forProposedRect: nil, context: nil, hints: nil) else { exit(1) }
let req = VNRecognizeTextRequest()
req.recognitionLevel = .accurate
req.recognitionLanguages = ["pt-BR"]
req.usesLanguageCorrection = false
try VNImageRequestHandler(cgImage: cg, options: [:]).perform([req])
let obs = (req.results ?? []).sorted { $0.boundingBox.midY > $1.boundingBox.midY }
for o in obs { print(o.topCandidates(1)[0].string) }
