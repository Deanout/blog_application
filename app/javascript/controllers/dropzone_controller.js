import { Controller } from "@hotwired/stimulus";
import Dropzone from "dropzone";
import { DirectUpload } from "@rails/activestorage";
import {
  getMetaValue,
  findElement,
  removeElement,
  insertAfter,
} from "../helpers/dropzone";

// Connects to data-controller="dropzone"
export default class extends Controller {
  static targets = ["input"];

  connect() {
    console.log("Connected to the dropzone controller");
    this.dropZone = createDropZone(this);
    this.hideFileInput();
    this.bindEvents();
    Dropzone.autoDiscover = false; // necessary quirk for Dropzone error in console
  }

  hideFileInput() {
    this.inputTarget.style.display = "none";
    this.inputTarget.disabled = true;
  }

  bindEvents() {
    this.dropZone.on("addedfile", (file) => {
      setTimeout(() => {
        file.accepted && createDirectUploadController(this, file).start();
      }, 500);
    });

    this.dropZone.on("removedfile", (file) => {
      file.controller && removeElement(file.controller.hiddenInput);
    });
    this.dropZone.on("canceled", (file) => {
      file.controller && file.controller.xhr.abort();
    });
    this.dropZone.on("processing", (file) => {
      this.submitButton.disabled = true;
    });
    this.dropZone.on("queuecomplete", (file) => {
      this.submitButton.disabled = false;
    });
  }

  get headers() {
    return { "X-CSRF-Token": getMetaValue("csrf-token") };
  }
  get url() {
    return this.inputTarget.getAttribute("data-direct-upload-url");
  }
  get maxFiles() {
    return this.data.get("maxFiles") || 1;
  }
  get maxFileSize() {
    return this.data.get("maxFileSize") || 256;
  }
  get acceptedFiles() {
    return this.data.get("acceptedFiles");
  }

  get addRemoveLinks() {
    return this.data.get("addRemoveLinks") || true;
  }
  get uploadMultiple() {
    return this.data.get("uploadMultiple") || false;
  }
  get form() {
    return this.element.closest("form");
  }
  get submitButton() {
    return findElement(this.form, "input[type=submit], button[type=submit]");
  }
}
class DirectUploadController {
  constructor(source, file) {
    this.directUpload = createDirectUpload(file, source.url, this);
    this.source = source;
    this.file = file;
  }
  start() {
    this.file.controller = this;
    this.hiddenInput = this.createHiddenInput();
    this.directUpload.create((error, attributes) => {
      if (error) {
        removeElement(this.hiddenInput);
        this.emitDropzoneError(error);
      } else {
        this.hiddenInput.value = attributes.signed_id;
        this.emitDropzoneSuccess();
      }
    });
  }
  createHiddenInput() {
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = this.source.inputTarget.name;
    insertAfter(input, this.source.inputTarget);
    return input;
  }
  directUploadWillStoreFileWithXHR(xhr) {
    this.bindProgressEvent(xhr);
    this.emitDropzoneUploading();
  }
  bindProgressEvent(xhr) {
    this.xhr = xhr;
    this.xhr.upload.addEventListener("progress", (event) =>
      this.uploadRequestDidProgress(event)
    );
  }
  uploadRequestDidProgress(event) {
    const element = this.source.element;
    const progress = (event.loaded / event.total) * 100;
    findElement(
      this.file.previewTemplate,
      ".dz-upload"
    ).style.width = `${progress}%`;
  }

  emitDropzoneUploading() {
    this.file.status = Dropzone.UPLOADING;
    this.source.dropZone.emit("processing", this.file);
  }

  emitDropzoneError(error) {
    this.file.status = Dropzone.ERROR;
    this.source.dropZone.emit("error", this.file, error);
    this.source.dropZone.emit("complete", this.file);
  }
  emitDropzoneSuccess() {
    this.file.status = Dropzone.SUCCESS;
    this.source.dropZone.emit("success", this.file);
    this.source.dropZone.emit("complete", this.file);
  }
}

function createDirectUploadController(source, file) {
  return new DirectUploadController(source, file);
}

function createDirectUpload(file, url, controller) {
  return new DirectUpload(file, url, controller);
}

function createDropZone(controller) {
  let dropzone = new Dropzone(controller.element, {
    url: controller.url,
    headers: controller.headers,
    maxFiles: controller.maxFiles,
    maxFilesize: controller.maxFileSize,
    acceptedFiles: controller.acceptedFiles,
    addRemoveLinks: controller.addRemoveLinks,
    uploadMultiple: controller.uploadMultiple,
    autoQueue: false,
  });
  console.log(dropzone);
  return dropzone;
}
