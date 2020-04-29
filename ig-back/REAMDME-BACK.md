# REST API

These API endpoints let you get, add, edit, and delete categories, images, and tags.

## 1) Routes categories
### Get categories
``` GET api/categories ```
#### Response
```
{
  "@context": "/api/contexts/Category",
  "@id": "/api/categories",
  "@type": "hydra:Collection",
  "hydra:member": [],
  "hydra:totalItems": 0
}
```
### Get a single category
``` GET api/categories/{id} ```
#### Parameters
| Name        | Type         | Description |
| ------------- |:-------------:| -----:|
| id      | int, AI      |  ***  |
#### Response
```
{
   “state”: “success”,
   “data”: {
      “id”: 5,
      “title”: ”Voiture”,
      “added_at”: “2020-03-31”,
      “updated_at”: “2020-03-31”
   }
}
```
### Add a category
``` POST api/categories ```
#### Parameters
| Name        | Type         | Description |
| ------------- |:-------------:| -----:|
| title      | VARCHAR(100)      |  ***  |
| added_at | DATE      |  ***   |
| updated_at | DATE      |  ***   |
#### Response
```
{
  “state”: “success”,
  “message”: “La catégorie à bien été ajoutée”
}
```
### Replace a category
``` PUT api/categories/{id} ```
#### Parameters
| Name        | Type         | Description |
| ------------- |:-------------:| -----:|
| id      | int, AI      |  ***  |
| title | VARCHAR(100)      |  ***   |
| updated_at | DATE      |  ***   |
#### Response
```
Réponse :
{
   “state”: “success”,
   “message”: “La catégorie à bien été mise à jour”
}
```
### Update a category
``` PATCH api/categories/{id} ```
#### Parameters
| Name        | Type         | Description |
| ------------- |:-------------:| -----:|
| id      | int, AI      |  ***  |
| title | VARCHAR(100)      |  ***   |
| updated_at | DATE      |  ***   |
#### Response
```
Réponse :
{
   “state”: “success”,
   “message”: “La catégorie à bien été mise à jour”
}
```
### Delete a category
``` DELETE api/categories/{id} ```
#### Parameters
| Name        | Type         | Description |
| ------------- |:-------------:| -----:|
| id      | int, AI      |  ***  |
#### Response
```
Réponse :
{
   “state”: “success”,
   “message”: “La catégorie à bien été supprimée”
}
```

## 2) Routes images
### Get images
``` GET api/images ```
#### Response
```
{
  "@context": "/api/contexts/Image",
  "@id": "/api/images",
  "@type": "hydra:Collection",
  "hydra:member": [],
  "hydra:totalItems": 0
}
```
### Get an image
``` GET api/images/{id} ```
#### Parameters
| Name        | Type         | Description |
| ------------- |:-------------:| -----:|
| id      | int, AI      |  ***  |
#### Response
```
Réponse :
{
   “state”: “success”,
   “data”: {
      “id”: 2,
      “category_id”: 5
      “path”: ”/images/bmw.jpg”,
      “description”: “Voici une voiture trop bien”
      “added_at”: “2020-03-31”,
      “updated_at”: “2020-03-31”,
      “category”: {
         “id”: 5,
         “title”: ”Voiture”,
         “added_at”: “2020-03-31”,
         “updated_at”: “2020-03-31”
      },
      “tags”: [
         {
            id: 2,
            title: “Rouge”,
            added_at: ”2020-03-31”,
            updated_at: “2020-03-31”
         }
      ]
   }
  }
```
### Add an image
``` POST api/images/{object} ```
#### Parameters
| Name        | Type         | Description |
| ------------- |:-------------:| -----:|
| category_id      | int      |  ***  |
| path      | VARCHAR(255)      |  ***  |
| description      | TEXT      |  ***  |
| added_at      | DATE      |  ***  |
| updated_at      | DATE      |  ***  |
#### Response
```
Réponse :
{
  “state”: “success”,
  “message”: “L’image à bien été ajoutée”
}
```
### Replace an image
``` PUT api/images/{id} ```
#### Parameters
| Name        | Type         | Description |
| ------------- |:-------------:| -----:|
| id      | int      |  ***  |
| category_id      | int      |  ***  |
| path      | VARCHAR(255)      |  ***  |
| description      | TEXT      |  ***  |
| added_at      | DATE      |  ***  |
| updated_at      | DATE      |  ***  |
#### Response
```
{
   “state”: “success”,
   “message”: “L’image à bien été mise à jour”
}
```
### Update an image
``` PATCH api/images/{id} ```
#### Parameters
| Name        | Type         | Description |
| ------------- |:-------------:| -----:|
| id      | int      |  ***  |
| category_id      | int      |  ***  |
| path      | VARCHAR(255)      |  ***  |
| description      | TEXT      |  ***  |
| added_at      | DATE      |  ***  |
| updated_at      | DATE      |  ***  |
#### Response
```
{
   “state”: “success”,
   “message”: “L’image à bien été mise à jour”
}
```
### Delete an image
``` DELETE api/images/{id} ```
#### Parameters
| Name        | Type         | Description |
| ------------- |:-------------:| -----:|
| id      | int      |  ***  |
#### Response
```
{
   “state”: “success”,
   “message”: “L’image à bien été supprimée”
}
```
## 3) Routes tags
### Get tags
``` GET api/tags ```
#### Response
```
{
  "@context": "/api/contexts/Tag",
  "@id": "/api/tags",
  "@type": "hydra:Collection",
  "hydra:member": [],
  "hydra:totalItems": 0
}
```
### Get a tag
``` GET api/tags/{id} ```
#### Parameters
| Name        | Type         | Description |
| ------------- |:-------------:| -----:|
| id      | int      |  ***  |
#### Response
```
{
   “state”: “success”,
   “data”: {
      “id: 2,
      “title”: “Rouge”,
      “added_at”: ”2020-03-31”,
      “updated_at”: “2020-03-31”
   }
```
### Add a tag
``` POST api/tags/{object} ```
#### Parameters
| Name        | Type         | Description |
| ------------- |:-------------:| -----:|
| title      | VARCHAR(100)      |  ***  |
| added_at      | DATE      |  ***  |
| updated_at      | DATE      |  ***  |
#### Response
```
{
  “state”: “success”,
  “message”: “Le tag à bien été ajouté”
}
```
### Replace a tag
``` PUT api/tags/{id} ```
#### Parameters
| Name        | Type         | Description |
| ------------- |:-------------:| -----:|
| id      | int, IA      |  ***  |
| title      | VARCHAR(100)      |  ***  |
| updated_at      | DATE      |  ***  |
#### Response
```
{
   “state”: “success”,
   “message”: “Le tag à bien été mis à jour”
}
```
### Update a tag
``` PATCH api/tags/{id} ```
#### Parameters
| Name        | Type         | Description |
| ------------- |:-------------:| -----:|
| id      | int, IA      |  ***  |
| title      | VARCHAR(100)      |  ***  |
| updated_at      | DATE      |  ***  |
#### Response
```
{
   “state”: “success”,
   “message”: “Le tag à bien été mis à jour”
}
```
### Delete a tag
``` DELETE api/tags/{id} ```
#### Parameters
| Name        | Type         | Description |
| ------------- |:-------------:| -----:|
| id      | int      |  ***  |
#### Response
```
{
   “state”: “success”,
   “message”: “Le tag à bien été supprimé”
}
```