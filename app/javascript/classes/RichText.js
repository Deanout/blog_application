export class RichText {
  constructor(picker, emojiButton) {
    this.picker = picker;
    this.emojiButton = emojiButton;
    this.createEmojiPickerButton();
  }
  createEmojiPickerButton() {
    this.emojiButton.addEventListener(
      "click",
      this.toggleEmojiPicker.bind(this)
    );
    document
      .querySelector("[data-trix-button-group=block-tools]")
      .prepend(this.emojiButton);
  }
  toggleEmojiPicker(event) {
    this.picker.toggle();
  }
  setPicker(picker) {
    this.picker = picker;
  }
}
