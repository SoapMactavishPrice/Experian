var j$ = jQuery.noConflict();
j$(document).ready(function () {
    console.log("Ready File Jqery");
    //Event listener for click of Upload button
    // j$("#uploadButton").click(function(){
    // 	console.log("#uploadButton Click");
    // 	prepareFileUploads();
    // });

    //Event listener to clear upload details/status bars once upload is complete
    j$("#clear").on('click', function () {
        j$(".upload").remove();
    });
});

var byteChunkArray;
var files;
var currentFile = [];
var indexArray = []; // IndexArra for changing the name of file with ChangeFileName array while storing to Salesforce;
var $upload;
var CHUNK_SIZE = 2000000; //Must be evenly divisible by 3, if not, data corruption will occur
let numOfFullChunks = 0;
var VIEW_URL = '/servlet/servlet.FileDownload?file=';
var parentId;
var ChangeFIleName = [{name : 'RBI_Certificate'},{name : 'Pan_Card'},{name : 'GST_Number'}]
// , you will see this variable used below but it is set in the component as this is a dynamic value passed in by component attribute

// function invalid(){
//     angular.element('input.ng-invalid').first().focus();
// }

function refreshFileField(fileFieldId) {
    console.log('file getting refreshed');
    document.getElementById(fileFieldId).value = "";
    // document.getElementById("").val("");
}

var checkForUploads = function (fileFieldIdsArray) {
    console.log(fileFieldIdsArray);
    return new Promise(function (resolve, rejected) {
        console.log("CheckForUpload Click");
        console.log(fileFieldIdsArray);
        byteChunkArray = new Array();
        var fieldarray = fileFieldIdsArray;
        for (let i = 0,j=0; i < fieldarray.length; i++) {
            // console.log('-document.getElementById(fieldarray[i]).files[0]--->'+document.getElementById(fieldarray[i]).files[0]);
            if(document.getElementById(fieldarray[i]).files[0] != undefined){
                console.log("Why true is here"+document.getElementById(fieldarray[i]).files[0]);
                currentFile[i] = document.getElementById(fieldarray[i]).files[0];
                indexArray[j] = i;
                console.log("currentFile", currentFile[i]);
                /*Build the byteChunkArray array for the current file we are processing. This array is formatted as:
                ['0-179999','180000-359999',etc] and represents the chunks of bytes that will be uploaded individually.*/
                
                //First check to see if file size is less than the chunk size, if so first and only chunk is entire size of file
                // if (currentFile[j].size) {
                //     byteChunkArray[j] = '0-' + (currentFile[j].size - 1);
                //     j++;
                //     console.log("CheckForUpload Click   IF");
                // }

                if(currentFile[i].size <= CHUNK_SIZE){
                    console.log("currentFile[i].size ", currentFile[i].size);
                    byteChunkArray[0] = '0-' + (currentFile[i].size - 1);
                   // byteChunkArray[i] = '0-' + (currentFile[i].size - 1);
                }else
                {
                    //Determine how many whole byte chunks make up the file,
                    console.log("currentFile[i].size ", currentFile[i].size);
                    var numOfFullChunks = Math.floor(currentFile[i].size / CHUNK_SIZE); //i.e. 1.2MB file would be 1000000 / CHUNK_SIZE
                    console.log("numOfFullChunks ", numOfFullChunks);
                    var remainderBytes = currentFile[i].size % CHUNK_SIZE; // would determine remainder of 1200000 bytes that is not a full chunk
                    console.log("remainderBytes ", remainderBytes);
                    var startByte = 0;
                    var endByte = CHUNK_SIZE - 1;
                    console.log("numOfFullChunks ", numOfFullChunks);
                    //Loop through the number of full chunks and build the byteChunkArray array
                    for(k = 0; k < numOfFullChunks; k++){
                        byteChunkArray[k] = startByte+'-'+endByte;
                        
                        //Set new start and stop bytes for next iteration of loop
                        startByte = endByte + 1;
                        endByte += CHUNK_SIZE;
                        console.log("byteChunkArray[k] ", byteChunkArray[k]);
                    }
                    
                    //Add the last chunk of remaining bytes to the byteChunkArray
                    startByte = currentFile[i].size - remainderBytes;
                    endByte = currentFile[i].size;
                    byteChunkArray.push(startByte+'-'+endByte);
                }
            }
        }
        resolve("Done");
        // processByteChunkArray()
    })
}

//Uploads a chunk of bytes, if attachmentId is passed in it will attach the bytes to an existing attachment record
var processByteChunkArray = function (attachmentId, parent,fileTitle, controllerName) {
    return new Promise(function (resolve, rejected) {
        parentId = parent;
        console.log("processByteChunkArray", parentId);
        //Proceed if there are still values in the byteChunkArray, if none, all piece of the file have been uploaded
        var is = 0;
        console.log("currentFile ", currentFile);

        for (let is = 0; is < currentFile.length; is++) {
            console.log("currentFile :"+ is, currentFile);

            if (byteChunkArray[is]) {
                console.log("byteChunkArray", byteChunkArray[is]);
                //Determine the byte range that needs to uploaded, if byteChunkArray is like... ['0-179999','180000-359999']
                var indexes = byteChunkArray[is].split('-'); //... get the first index range '0-179999' -> ['0','179999']
                console.log("indexes", indexes);
                var startByte = parseInt(indexes[0]); //0
                var stopByte = parseInt(indexes[1]); //179999

                //Slice the part of the file we want to upload, currentFile variable is set in checkForUploads() method that is called before this method
                if (currentFile[is].webkitSlice) {
                    var blobChunk = currentFile[is].webkitSlice(startByte, stopByte + 1);
                    console.log("Safari Blob", blobChunk);
                } else if (currentFile[is].mozSlice) {
                    var blobChunk = currentFile[is].mozSlice(startByte, stopByte + 1);
                    console.log("Mozila Blob", blobChunk);
                } else {
                    var blobChunk = currentFile[is].slice(startByte, stopByte + 1);
                    console.log("Other Blob", blobChunk);
                }
                //Create a new reader object, part of HTML5 File API
                var reader = new FileReader();

                //Read the blobChunk as a binary string, reader.onloadend function below is automatically called after this line
                reader.readAsBinaryString(blobChunk);

                //Create a reader.onload function, this will execute immediately after reader.readAsBinaryString() function above;
                reader.onloadend = function (evt) {
                    if (evt.target.readyState == FileReader.DONE) { //Make sure read was successful, DONE == 2
                        //Base 64 encode the data for transmission to the server with JS remoting, window.btoa currently on support by some browsers
                        var base64value = window.btoa(evt.target.result);
                       // console.log('base64value');
                       // console.log('base64value',base64value);
                       // console.log("CURRENT FILE---->", currentFile);
                       // console.log("is---->", is);
                       // console.log("CURRENT FILE---->", currentFile[is].name);
                        var tempName = currentFile[is].name;
                        var tempType = currentFile[is].type;

                        var idxDot = tempName.lastIndexOf(".") + 1;
                        var extFile = tempName.substr(idxDot, tempName.length).toLowerCase();
                        
                        if (controllerName == 'profileController') {
                            //Use js remoting to send the base64 encoded chunk for uploading
                            profileController.attachBlob(parentId, attachmentId, tempName, tempType, base64value, function (event, result) {
                                // console.log(attachmentId);
                                //Proceed if there were no errors with the remoting call
                                if (result.status == true) {
                                    console.log("Uploaded");
                                    byteChunkArray.shift(); //removes 0 index
							
                                    //Set the attachmentId of the file we are now processing
                                    attachmentId = result;
                                                        
                                    //Call process byteChunkArray to upload the next piece of the file
                                    processByteChunkArray(attachmentId,parentId,fileTitle,'profileController');
                                    // if(is == (currentFile.length - 1)){
                                        // resolve(result);
                                    // }
                                }else{
                                    if(is == (currentFile.length - 1)){
                                        rejected(result);
                                    }
                                }
                            });
                        }
                        if (controllerName == 'FormsCotroller') {
                            
                            /*var temp_I = indexArray[is];
                            tempName = ChangeFIleName[temp_I].name+'.'+extFile;  // Name of the file Changing while Saving to salesforce;
                            console.log("tempName FILE---->", tempName);
                            */
                            var uploadedFiles = [];
                            //uploadedFiles = JSON.parse(window.localStorage.getItem("uploadedFiles"));
                            //uploadedFiles = window.localStorage.getItem("uploadedFiles");
                            if(fileTitle == 'RBICertificate'){
                                window.localStorage.removeItem("uploadedFiles");
                            }
                            
                           if(window.localStorage.getItem("uploadedFiles") != null){
                            uploadedFiles = JSON.parse(window.localStorage.getItem("uploadedFiles"));
                           }
                            var file = {};
                            file.parentId = parentId;
                            file.tempName = tempName;
                            file.fileTitle = fileTitle;
                            //file.base64value = base64value;
                            uploadedFiles.push(file);
                            window.localStorage.setItem("uploadedFiles", JSON.stringify(uploadedFiles));
                            //window.localStorage.setItem(fileTitle, JSON.stringify(uploadedFiles));
                            console.log('FormsController : '+ fileTitle);
                            console.log('uploaded file list :');

                                if(fileTitle == 'RBICertificate'){
                                    document.getElementById('base64RBI').value = base64value;
                                
                                }else if(fileTitle == 'PanCard'){
                                    document.getElementById('base64PAN').value = base64value;
                                }else if(fileTitle == 'CompanyCertificate'){
                                    document.getElementById('base64COM').value = base64value;
                                }else if(fileTitle == 'GSTCertificate'){
                                    document.getElementById('base64GST').value = base64value;
                                }
                          // console.log(JSON.parse(window.localStorage.getItem("uploadedFiles")));
                           
                           /*
                            FormsCotroller.attachBlob(parentId, tempName,fileTitle, base64value, function (event, result) {
                                //Proceed if there were no errors with the remoting call
                                console.log('result',result);

                                if (result.status == true) {
                                    console.log("Uploaded");
                                    byteChunkArray.shift(); //removes 0 index
							
                                    //Set the attachmentId of the file we are now processing
                                    attachmentId = result;
                                                        
                                    //Call process byteChunkArray to upload the next piece of the file
                                    processByteChunkArray(attachmentId,parentId,fileTitle,'FormsCotroller');
                                    // if(is == (currentFile.length - 1)){
                                        // resolve(result);
                                    // }
                                }else{
                                    if(is == (currentFile.length - 1)){
                                        rejected(result);
                                    }
                                }
                            });
                            */
                        }
                        if (controllerName == 'membrAccOpngFormController') {

                            tempName = ChangeFIleName[is].name+'.'+extFile;  // Name of the file Changing while Saving to salesforce;
                            console.log("tempName FILE---->", tempName);
                            console.log(attachmentId[is]);
                            membrAccOpngFormController.attachBlob(parentId, attachmentId[is], tempName, tempType, base64value, function (event, result) {
                                //Proceed if there were no errors with the remoting call
                                if (event.status == true) {
                                    console.log("Uploaded",is,currentFile.length - 1);
                                    if(is == (currentFile.length - 1)){
                                        resolve(result);
                                    }
                                }else{
                                    if(is == (currentFile.length - 1)){
                                        rejected(result);
                                    }
                                }
                            });
                        }
                    };
                }

            } else {
                console.log('END Uploading')
                break;
                //This file has completed, all byte chunks have been uploaded, set status on the div to complete
                // $upload.attr('data-status', 'complete');

                //Change name of file to link of uploaded attachment
                // $upload.find(".name").html('<a href="' + VIEW_URL + attachmentId + '" target="_blank">' + currentFile[i].name + '</a>');

                //Call the checkForUploads to find the next upload div that has data-status="incomplete" and start the upload process. 
                // checkForUploads();
            }
        }
        resolve({status : true});
    })
}

// function processByteChunkArray(attachmentId, parent, controllerName) {
//     parentId = parent;
//     console.log("processByteChunkArray", parentId);
//     //Proceed if there are still values in the byteChunkArray, if none, all piece of the file have been uploaded
//     var is = 0;
//     for (let is = 0; is < currentFile.length; is++) {
//         if (byteChunkArray[is]) {
//             console.log("byteChunkArray", byteChunkArray[is]);
//             //Determine the byte range that needs to uploaded, if byteChunkArray is like... ['0-179999','180000-359999']
//             var indexes = byteChunkArray[is].split('-'); //... get the first index range '0-179999' -> ['0','179999']
//             console.log("indexes", indexes);
//             var startByte = parseInt(indexes[0]); //0
//             var stopByte = parseInt(indexes[1]); //179999

//             //Slice the part of the file we want to upload, currentFile variable is set in checkForUploads() method that is called before this method
//             if (currentFile[is].webkitSlice) {
//                 var blobChunk = currentFile[is].webkitSlice(startByte, stopByte + 1);
//                 console.log("Safari Blob", blobChunk);
//             } else if (currentFile[is].mozSlice) {
//                 var blobChunk = currentFile[is].mozSlice(startByte, stopByte + 1);
//                 console.log("Mozila Blob", blobChunk);
//             } else {
//                 var blobChunk = currentFile[is].slice(startByte, stopByte + 1);
//                 console.log("Other Blob", blobChunk);
//             }
//             //Create a new reader object, part of HTML5 File API
//             var reader = new FileReader();

//             //Read the blobChunk as a binary string, reader.onloadend function below is automatically called after this line
//             reader.readAsBinaryString(blobChunk);

//             //Create a reader.onload function, this will execute immediately after reader.readAsBinaryString() function above;
//             reader.onloadend = function (evt) {
//                 if (evt.target.readyState == FileReader.DONE) { //Make sure read was successful, DONE == 2
//                     //Base 64 encode the data for transmission to the server with JS remoting, window.btoa currently on support by some browsers
//                     var base64value = window.btoa(evt.target.result);
//                     console.log("CURRENT FILE---->", currentFile);
//                     console.log("is---->", is);
//                     console.log("CURRENT FILE---->", currentFile[is].name);
//                     var tempName = currentFile[is].name;
//                     var tempType = currentFile[is].type;

//                     if (controllerName == 'profileController') {
//                         //Use js remoting to send the base64 encoded chunk for uploading
//                         profileController.attachBlob(parentId, attachmentId, tempName, tempType, base64value, function (result, event) {

//                             //Proceed if there were no errors with the remoting call
//                             if (event.status == true) {
//                                 console.log("Uploaded");
//                             }
//                         });
//                     }
//                     if (controllerName == 'memberRegisterDocUpload') {
//                         console.log(attachmentId);
//                         console.log(parentId);
//                         memberRegisterDocUpload.attachBlob(parentId, attachmentId, tempName, tempType, base64value, function (result, event) {

//                             //Proceed if there were no errors with the remoting call
//                             if (event.status == true) {
//                                 console.log("Uploaded");
//                             }
//                         });
//                     }
//                 };
//             }

//         } else {
//             //This file has completed, all byte chunks have been uploaded, set status on the div to complete
//             $upload.attr('data-status', 'complete');

//             //Change name of file to link of uploaded attachment
//             $upload.find(".name").html('<a href="' + VIEW_URL + attachmentId + '" target="_blank">' + currentFile[i].name + '</a>');

//             //Call the checkForUploads to find the next upload div that has data-status="incomplete" and start the upload process. 
//             // checkForUploads();
//         }
//     }
// }


// Call This Two Function One by One in Angular or Javacript to exceute 

// jQuery(checkForUploads());
// jQuery(processByteChunkArray('',result.applicantDId));