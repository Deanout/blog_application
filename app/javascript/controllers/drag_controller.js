import { Controller } from "@hotwired/stimulus";

/**
 * The data attribute containing the draggable element's id.
 */
const dataResourceID = "data-resource-id";
/**
 * The data attribute containing the draggable element's outer parent,
 * to prevent traversing up to the document root.
 */
const dataParent = "data-parent";
/**
 * The remote URL to submit draggable list order changes to.
 */
let url;
/**
 * The draggable element's id.
 */
let resourceID;
/**
 * The draggable element's new position. In JavaScript this is 0 based,
 * but in Rails this will be 1 based (IDs are 1 based for records).
 */
let newPosition;
// Connects to data-controller="drag"
export default class extends Controller {
  connect() {}
  /**
   * Called when the user starts dragging an element.
   *
   * @param {*} event The drag event, which can be used to access the dragged element.
   */
  dragStart(event) {
    resourceID = event.target.getAttribute(dataResourceID);
    url = event.target.getAttribute("data-url");
    event.dataTransfer.effectAllowed = "move";
  }
  /**
   * Called when the user drags an element over another element and releases
   * the mouse button.
   *
   * @param {*} event The drag event, which can be used to access the dragged element.
   */
  drop(event) {
    event.preventDefault();
    let parentID = event.target.getAttribute(dataParent);
    const dropTarget = this.findDropTarget(event.target, parentID);
    const draggedItem = document.querySelector(
      `[data-resource-id="${resourceID}"]`
    );
    if (draggedItem === null || dropTarget === null) {
      return true;
    }
    this.setNewPosition(dropTarget, draggedItem, event);
    newPosition = [...this.element.parentElement.children].indexOf(draggedItem);
  }
  /**
   * Called after the drag event has stopped. This runs after the drop event.
   *
   * @param {*} event The drag event, which can be used to access the dragged element.
   */
  dragEnd(event) {
    event.preventDefault();
    if (resourceID === null || newPosition === null) {
      return;
    }
    let data = JSON.stringify({
      resource: {
        id: resourceID,
        position: newPosition,
      },
    });
    fetch(url, {
      method: "PATCH",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.getMetaValue("csrf-token"),
        "Content-Type": "application/json",
      },
      body: data,
    });
  }
  /**
   * Called when the user drags an element over another element.
   *
   * @param {*} event The drag event, which can be used to access the dragged element.
   */
  dragOver(event) {
    event.preventDefault();
    return true;
  }
  /**
   * Called when the mouse is dragged over another element
   *
   * @param {*} event The drag event, which can be used to access the dragged element.
   */
  dragEnter(event) {
    event.preventDefault();
  }
  /**
   * Attempts to find the appropriate draggable element in order to parent
   * the dragged item to the correct element. This ensures that items aren't
   * dropped inside of each other, rather than on top of each other.
   *
   * @param {*} target The element that the dragged element is dropped on.
   * @param {*} parentID The ID of the parent element. This is used to prevent
   *                      traversing up to the document root.
   * @returns The element that the dragged element should be parented to.
   */
  findDropTarget(target, parentID) {
    if (target === null) {
      return null;
    }
    if (target.id === parentID) {
      return null;
    }
    if (target.classList.contains("draggable")) {
      return target;
    }
    return this.findDropTarget(target.parentElement, parentID);
  }
  /**
   * Sets the new position of the dragged element. Positions in the JavaScript
   * controller are 0 based, but the positions in the Rails gem are 1 based.
   *
   * So this index is incremented by 1 on the server side after it is sent over,
   * to match the ID.
   *
   * @param {*} dropTarget The element that the dragged element is dropped on.
   * @param {*} draggedItem The element that is being dragged.
   */
  setNewPosition(dropTarget, draggedItem) {
    const positionComparison = dropTarget.compareDocumentPosition(draggedItem);
    if (positionComparison & Node.DOCUMENT_POSITION_FOLLOWING) {
      dropTarget.insertAdjacentElement("beforebegin", draggedItem);
    } else if (positionComparison & Node.DOCUMENT_POSITION_PRECEDING) {
      dropTarget.insertAdjacentElement("afterend", draggedItem);
    }
  }
  /**
   * Gets the value of the meta tag with the given name. This is used to
   * get the CSRF token.
   *
   * @param {*} name The name of the meta tag.
   * @returns The value of the meta tag.
   */
  getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`);
    return element.getAttribute("content");
  }
}
