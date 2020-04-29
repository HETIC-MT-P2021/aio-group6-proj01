module ApiEndpoint exposing (..)

getHostname : String
getHostname =
    "http://localhost:8001/api"

getImagesList : String
getImagesList =
    getHostname ++ "/images"

getImage : String
getImage =
    getHostname ++ "/images/"

postImage : String
postImage =
    getHostname ++ "/images"

putImage : String
putImage =
    getHostname ++ "/images/"

deleteImage : String
deleteImage =
    getHostname ++ "/images/"

getCategoriesList : String
getCategoriesList =
    getHostname ++ "/categories"

getCategory : String
getCategory =
    getHostname ++ "/categories/"

postCategory : String
postCategory =
    getHostname ++ "/categories"

putCategory : String
putCategory =
    getHostname ++ "/categories/"

deleteCategory : String
deleteCategory =
    getHostname ++ "/categories/"