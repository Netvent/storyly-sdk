
# Storyly External API
Storyly External API is used to manage your apps, story groups and stories via HTTP requests. 
## Getting Started
To use the external API, you will need to create a unique API Token from dashboard. Login to dashboard, navigate to `Settings  > User Settings` page, where you can create or update your token. This token provides read and write access to your account, so do not share or distribute it. Do not use this API to publish your stories to any platform, as it is rate limited and your token will be exposed.
## Endpoints
Storyly External API base URL is: `https://api.storyly.io/api`

Currently available endpoints are: `/app`  `/story_group` `/story`

Token should be provided on query string of each API request, such as:  `https://api.storyly.io/api/app?token={your_token_here}`

Available filters and parameters (will be described in detail below) can be added to query string.

All post / patch request bodies should be in JSON format and `Content-Type: applicaton/json` should be added to request header.
## App Endpoint
App endpoint allows list, create and delete actions.
### List
Returns list of apps based on provided filters.
Request Method: `GET`
#### Available Filters:
 - `id=id_of_app` Optional. When provided, app with given ID will be listed.
#### Available Parameters:
 - `inc_groups=true` Optional. When provided, story groups related with apps will be listed on response.
 - `inc_stories=true` Optional. When provided, stories and story groups related with apps will be listed on response.
#### Sample Request:
`GET: https://api.storyly.io/api/app?token={your_token_here}&id=1&inc_stories=true`

Response Body:
```json
{
    "status": "ok",
    "message": "success",
    "data": [
        {
            "id": 1,
            "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhcHBfaWQiOjEwfQ",
            "title": "com.play.store.id",
            "store_id": "com.play.store.id",
            "store_type": "play",
            "category": "Games",
            "detailed_info": "{\"title\": \"Game App\", \"category\": \"Games\", \"icon\": \"https://prod-storyly-media.s3-eu-west-1.amazonaws.com/html-templates/appIcon.png\", \"developer\": \"AppSamurai\", \"market_url\": \"https://play.google.com/store/apps\"}",
            "settings": null,
            "ts_created": "2020-02-20 15:17:31",
            "ts_updated": "2020-02-20 15:17:32",
            "story_groups": [
                {
                    "id": 5,
                    "app_id": 1,
                    "title": "Test Story group",
                    "icon": "https://692672286615-storyly.s3.amazonaws.com/files/35/6203e45c-003e-40ee-bf78-9e916e771f6b--custom4.png",
                    "target_cap": null,
                    "pinned": false,
                    "sort_order": 4,
                    "settings": null,
                    "status": 1,
                    "views": 0,
                    "ts_start": "2020-02-20 12:18:13",
                    "ts_end": null,
                    "ts_created": "2020-02-20 15:18:31",
                    "ts_updated": "2020-02-24 11:03:50",
                    "stories": [
                        {
                            "id": 15677,
                            "story_group_id": 5,
                            "type": 1,
                            "title": "Test",
                            "sort_order": 0,
                            "media": "https://db62cod6cnasq.cloudfront.net/user-media/14/c2954b14-c845-4a0d-949b-4e2e292d132e--coverrvehiclesonthehighway1567243769917.jpg",
                            "mime_type": "image/jpg",
                            "button_text": "",
                            "outlink": "",
                            "settings": null,
                            "status": 1,
                            "views": 0,
                            "ts_start": "2020-02-20 16:24:10",
                            "ts_end": null,
                            "ts_created": "2020-02-20 16:24:10",
                            "ts_updated": "2020-02-20 16:24:10"
                        }
                    ]
                }
            ]
        }
    ]
}
```
 ---
### Create
Create an app record.
Request Method: `Post`
#### Sample Request:
`POST: https://api.storyly.io/api/app?token={your_token_here}`

Request Body: 
```json
{
    "app_id": "com.package.id"
}
```
Response Body:
```json
{
    "status": "ok",
    "message": "App successfully created",
    "data": {
        "id": 12,
        "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhcHBfaWQiOjEyfQ.mlcoJufNxYqiSNcGMBp4_s9WVuk_S8Lxxax4ditil4k",
        "title": "Crystalborne: Heroes of Fate",
        "store_id": "com.arenaofstarsonline.chof",
        "store_type": "play",
        "category": "Role Playing",
        "detailed_info": "{\"rating\": 3.9503104686737, \"contains_ads\": false, \"package_name\": \"com.arenaofstarsonline.chof\", \"short_desc\": \"Assemble your team and join the best-in-class strategy RPG game!\", \"ratings_1\": 879",
        "settings": null,
        "ts_created": "2020-02-25 13:17:42",
        "ts_updated": "2020-02-25 13:17:43",
        "story_groups": []
    }
}
```
---
### Delete
Delete app record and all story groups / stories related with that app. Deletes the records permanently, data will not be recoverable.
Request Method: `Delete`
#### Sample Request:
`DELETE: https://api.storyly.io/api/app?token={your_token_here}&app_id=1`

Response Body:
```json
{
    "status":  "ok",
    "message":  "App successfully deleted",
    "data":  null
}
```
## Story Group Endpoint
Story Group Endpoint allows list, create, update and delete actions.
### List
Returns list of story groups based on provided filters.
`Request Method: GET`
#### Available Filters:
 - `id=id_of_story_group` Optional. When provided, story group with given ID will be listed.
#### Available Parameters:
 - `inc_stories=true` Optional. When provided, stories of related story groups will be listed on response.
#### Sample Request:
`GET: https://api.storyly.io/api/story_group?token={your_token_here}&id=1&inc_stories=true`

Response Body:
```json
{
    "status": "ok",
    "message": "success",
    "data": [
        {
            "id": 1,
            "app_id": 11,
            "title": "Test group",
            "icon": "https://692672286615-storyly.s3.amazonaws.com/files/35/a7253aad-68d1-41fc-b9e7-fccb2a0a50d2--6203e45c003e40eebf789e916e771f6bcustom4.png",
            "target_cap": null,
            "pinned": false,
            "sort_order": 0,
            "settings": null,
            "status": 1,
            "views": 0,
            "ts_start": "2020-02-20 12:18:13",
            "ts_end": null,
            "ts_created": "2020-02-24 13:32:17",
            "ts_updated": "2020-02-24 16:13:40",
            "stories": [
                {
                    "id": 15681,
                    "story_group_id": 10,
                    "type": 1,
                    "title": "Test",
                    "sort_order": 0,
                    "media": "https://db62cod6cnasq.cloudfront.net/user-media/14/c2954b14-c845-4a0d-949b-4e2e292d132e--coverrvehiclesonthehighway1567243769917.jpg",
                    "mime_type": "image/jpg",
                    "button_text": "",
                    "outlink": "",
                    "settings": null,
                    "status": 1,
                    "views": 0,
                    "ts_start": "2020-02-24 16:09:04",
                    "ts_end": null,
                    "ts_created": "2020-02-24 16:09:04",
                    "ts_updated": "2020-02-24 16:09:04"
                }
            ]
        }
    ]
}
```
---
### Create
Create a story group record.
Request Method: `Post`
#### Sample Request:
`POST: https://api.storyly.io/api/story_group?token={your_token_here}`

Request Body: 
```json
{
    "app_id": 11,
    "title": "Test group",
    "icon": "https://yourserver.com/hosted_files/image.png",
    "target_cap": null,
    "pinned": false,
    "sort_order": 0,
    "settings": {},
    "status": 1,
    "ts_start": "2020-02-20 12:18:13",
    "ts_end": null
}
```
Response:
```json
{
    "status": "ok",
    "message": "Story Group created successfully",
    "data": {
        "id": 12,
        "app_id": 11,
        "title": "Test group",
        "icon": "https://692672286615-storyly.s3.amazonaws.com/files/35/65d958e7-bc82-4783-885b-e82b7750b676--6203e45c003e40eebf789e916e771f6bcustom4.png",
        "target_cap": null,
        "pinned": false,
        "sort_order": 0,
        "settings": {},
        "status": 1,
        "views": 0,
        "ts_start": "2020-02-20 12:18:13",
        "ts_end": null,
        "ts_created": "2020-02-25 14:43:15",
        "ts_updated": "2020-02-25 14:43:15",
        "stories": []
    }
}
```
---
### Update
Update a story group record.
Request Method: `PATCH`
#### Sample Request:
`PATCH: https://api.storyly.io/api/story_group?token={your_token_here}&story_group_id=1`

Request Body: 
```json
{
    "title": "Test group",
    "icon": "https://yourserver.com/hosted_files/image.png",
    "target_cap": null,
    "pinned": true,
    "sort_order": 0,
    "settings": {},
    "status": 1,
    "ts_start": "2020-02-20 12:18:13",
    "ts_end": null
}
```
Response:
```json
{
    "status": "ok",
    "message": "Story Group successfully updated",
    "data": {
        "id": 12,
        "app_id": 11,
        "title": "Test group",
        "icon": "https://692672286615-storyly.s3.amazonaws.com/files/35/de0dd564-fb5f-4b3d-8e92-6df8088db7f6--6203e45c003e40eebf789e916e771f6bcustom4.png",
        "target_cap": null,
        "pinned": true,
        "sort_order": 0,
        "settings": "{}",
        "status": 1,
        "views": 0,
        "ts_start": "2020-02-20 12:18:13",
        "ts_end": null,
        "ts_created": "2020-02-25 14:43:15",
        "ts_updated": "2020-02-25 14:58:47",
        "stories": []
    }
}
```
---
### Delete
Delete story group record and all stories related with that group. Deletes the records permanently, data will not be recoverable.
Request Method: `Delete`
#### Sample Request:
`DELETE: https://api.storyly.io/api/story_group?token={your_token_here}&story_group_id=1`

Response Body:
```json
{
    "status":  "ok",
    "message":  "Story Group successfully deleted",
    "data":  null
}
```
## Story Endpoint
Story Endpoint allows list, create, update and delete actions.
### List
Returns list of stories based on provided filters.
`Request Method: GET`
#### Available Filters:
 - `story_group_id=id_of_story_group` ***Required***. Stories of given story group will be listed.
#### Sample Request:
`GET: https://api.storyly.io/api/story?token={your_token_here}&story_group_id=1`

Response Body:
```json
{
    "status": "ok",
    "message": "success",
    "data": [
        {
            "id": 15681,
            "story_group_id": 10,
            "type": 1,
            "title": "Test",
            "sort_order": 0,
            "media": "https://db62cod6cnasq.cloudfront.net/files/35/53b810b9-fa3c-419b-a938-1919bc7bb976--ScreenShot20200205at11.18.50.png",
            "mime_type": "image/png",
            "button_text": "",
            "outlink": "",
            "settings": null,
            "status": 1,
            "views": 0,
            "ts_start": "2020-02-24 16:09:04",
            "ts_end": null,
            "ts_created": "2020-02-24 16:09:04",
            "ts_updated": "2020-02-24 16:09:04"
        }
    ]
}
```
---
### Create
Create a story record.
Request Method: `Post`
#### Sample Request:
`POST: https://api.storyly.io/api/story?token={your_token_here}`

Request Body: 
```json
{
    "story_group_id": 1,
    "type": 1,
    "title": "Story",
    "sort_order": 3,
    "media": "https://yourserver.com/hosted_files/image.png",
    "button_text": "",
    "outlink": "",
    "settings": {},
    "status": 1,
    "ts_start": "2020-02-25 16:21:58",
}
```
Response Body:
```json
{
    "status": "ok",
    "message": "Story successfully created",
    "data": {
        "id": 15680,
        "story_group_id": 1,
        "type": 1,
        "title": "Story",
        "sort_order": 3,
        "media": "https://692672286615-storyly.s3.amazonaws.com/files/35/99311b95-9020-4db1-9785-ce145442fe9b--6203e45c003e40eebf789e916e771f6bcustom4.png",
        "mime_type": "image/png",
        "button_text": "",
        "outlink": "",
        "settings": {},
        "status": 1,
        "views": 0,
        "ts_start": "2020-02-25 16:21:58",
        "ts_end": null,
        "ts_created": "2020-02-25 16:21:59",
        "ts_updated": "2020-02-25 16:21:59"
    }
}
```
---
### Update
Update a story record.
Request Method: `PATCH`
#### Sample Request:
`PATCH: https://api.storyly.io/api/story?token={your_token_here}&story_id=15680`

Request Body: 
```json
{
    "title": "Story",
    "sort_order": 3,
    "button_text": "Click Here",
    "outlink": "https://www.appsamurai.com",
    "settings": {},
    "status": 0
}
```
Response Body:
```json
{
    "status": "ok",
    "message": "Story successfully updated",
    "data": {
        "id": 15680,
        "story_group_id": 1,
        "type": 1,
        "title": "Story",
        "sort_order": 3,
        "media": "https://692672286615-storyly.s3.amazonaws.com/files/35/234041c9-0c33-4701-b3d4-f3a2aa8268bb--6203e45c003e40eebf789e916e771f6bcustom4.png",
        "mime_type": "image/png",
    "button_text": "Click Here",
        "outlink": "https://www.appsamurai.com",
        "settings": {},
        "status": 0,
        "views": 0,
        "ts_start": "2020-02-24 14:39:10",
        "ts_end": null,
        "ts_created": "2020-02-24 14:39:10",
        "ts_updated": "2020-02-25 16:34:54"
    }
}
```
---
### Delete
Delete story. Deletes the records permanently, data will not be recoverable.
Request Method: `Delete`
#### Sample Request:
`DELETE: https://api.storyly.io/api/story?token={your_token_here}&story_id=15680`

Response Body:
```json
{
    "status":  "ok",
    "message":  "Story successfully deleted",
    "data":  null
}
```
