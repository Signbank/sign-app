# API endpoint documentation
This API endpoint documentation is a comprehensive guide to all the possible requests that can be made to the Signbank and Sign app back-end using the RESTful design.
The documentation outlines the data that each request expects, including query parameters and request bodies, as well as the data that each request will return and the structure in which this data is represented.

## Signbank

### Sign info
The purpose of this request is to retrieve all the signs from the Signbank that match the user's search.
It scans the specified dataset for translations that start with the user-specified search term.
The response of this endpoint includes the names of the matching signs, as well as their corresponding thumbnail and video URL.

Request type: **GET**

| Arguments    | Required | Type | Description       |
| ------------ |:--------:|:----:| ----------------- |
| Search  | :white_check_mark: | String  | The search term is used to filter the signs in the Signbank. It searches for all translations of a sign that start with the specified term. For example, searching for *"a"* will return all signs whose translations begin with *"a"*, such as *"accept"*.|
| Dataset | :white_check_mark: | Integer | The parameter specifies the dataset the user would like to use, such as NGT or ASL. The dataset is identified by its ID in the Signbank database, so NGT would be represented as *"5"* when handling this request.|
| Results | :white_check_mark: | Integer | The *"results"* parameter limits the number of signs that are returned to the specified value.|

#### Request example

```
$ curl {signbank_base_url}/dictionary/gloss/api/?search=ac&dataset=5&results=2
```

#### Response example

```
[
  {
    "sign_name": "ACCEPTEREN-A",
    "video_url": "glossvideo/NGT/AC/ACCEPTEREN-A-51.mp4",
    "image_url": "glossimage/NGT/AC/ACCEPTEREN-A-51.png"
  },
  {
    "sign_name": "ACCEPTEREN-B",
    "video_url": "glossvideo/NGT/AC/ACCEPTEREN-B-3277.mp4",
    "image_url": "glossimage/NGT/AC/ACCEPTEREN-B-3277.png"
  }
]
```

### Sign info by ID list

The same information as the endpoint above can be retrieved using a POST request.
In this case, a list of sign IDs can be included in the request body to retrieve information for multiple signs at once.

Request type: **POST**

| Arguments    | Required | Type | Description       |
| ------------ |:--------:|:----:| ----------------- |
| Post body  | :white_check_mark: | List of integers  | The JSON list should contain a list of integers which are the IDs of the signs for which you want to retrieve the corresponding name and media information. | 

#### Request example

```
$ curl -X POST {signbank_base_url}/dictionary/gloss/api/ 
   -H "Content-Type: application/json"
   -d '[14, 736, 519]'
```

#### Response example

```
[
  {
    "sign_name": "ACCEPTEREN-A",
    "video_url": "glossvideo/NGT/AC/ACCEPTEREN-A-51.mp4",
    "image_url": "glossimage/NGT/AC/ACCEPTEREN-A-51.png"
  },
  {
    "sign_name": "ACCEPTEREN-B",
    "video_url": "glossvideo/NGT/AC/ACCEPTEREN-B-3277.mp4",
    "image_url": "glossimage/NGT/AC/ACCEPTEREN-B-3277.png"
  }
]
```
## Sign app
### Search by sign property

This endpoint can be used to find a sign by selecting properties.
It returns a list of properties from which one can be selected to filter the possible signs.
The endpoint expects a list of integers which correspond to the indexes of the selected items.

For example, at first, you would send an empty list, and the API would return a list of properties of the first type.
To select a property, you would make the request again and set the index of that property in a list.
So, if you pick the third property, the request body would become [2].
If you then choose the first item, the request body would become [2, 0].
This process can continue until there are no more property types to select.
When no more items can be selected, the API will return an empty list.

For a more in depth explanation of the underlying structure see the [documentation](documentation.md#tree).

Request type: **POST**

| Arguments    | Required | Type | Description       |
| ------------ |:--------:|:----:| ----------------- |
| Post body  | :white_check_mark: | List of integers  | The integers represent the index of the chosen property. | 

#### Request example

```
$ curl -X POST {sign_app_base_url}/search
   -H "Content-Type: application/json"
   -d '[4, 19]'
```

#### Response example

```
[
	{
		"identifier": "Neutrale ruimte",
		"sign_ids": [
			2109
		]
	},
	{
		"identifier": "Variabel",
		"sign_ids": [
			3091,
			36752,
			4042
		]
	}
]
```
