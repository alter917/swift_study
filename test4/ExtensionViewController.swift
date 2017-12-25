//
//
//  Created by hideyuki matsuura on 2017/12/25.
//  Copyright © 2017年 hideyuki matsuura. All rights reserved.
//

import Photos
extension ViewController:AVCapturePhotoCaptureDelegate {

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let photoData = photo.fileDataRepresentation() else {
            return
        }
        if let stillImage = UIImage(data: photoData) {
            UIImageWriteToSavedPhotosAlbum(stillImage, self, nil, nil)
        }
    }
    

}
