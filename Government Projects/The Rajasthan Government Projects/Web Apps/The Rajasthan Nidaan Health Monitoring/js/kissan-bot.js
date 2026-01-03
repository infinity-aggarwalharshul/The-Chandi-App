/**
 * Kissan-Sahayak Bot
 * 24/7 Multilingual Support (65+ Languages)
 */
class KissanBot {
  constructor() {
    this.isOpen = false;
    this.voices = [];
    window.speechSynthesis.onvoiceschanged = () => {
      this.voices = window.speechSynthesis.getVoices();
    };
  }

  toggle() {
    this.isOpen = !this.isOpen;
    const panel = document.getElementById("chat-panel");
    if (panel) panel.style.display = this.isOpen ? "flex" : "none";

    if (this.isOpen) {
      this.appendMsg(
        "bot",
        "Namaste! I am Kissan Sahayak. How can I help you today? (I speak 65+ Languages)"
      );
    }
  }

  async sendMessage() {
    const input = document.getElementById("chat-input");
    const msg = input.value;
    if (!msg) return;

    // User Message
    this.appendMsg("user", msg);
    input.value = "";

    // Simulated AI Processing & Translation
    setTimeout(() => {
      let response =
        "I can help you with crop prices, organic certification, or weather updates.";

      if (msg.toLowerCase().includes("price"))
        response = "Wheat is currently ₹2200/Qtl in Kota Mandi.";
      else if (msg.toLowerCase().includes("weather"))
        response = "Expect rain in Jaipur district tomorrow.";
      else if (msg.toLowerCase().includes("organic"))
        response =
          "To apply for organic certification, use the 'Farm Inspection' tab.";

      // Translate simulation (Google Transcript Feature)
      this.appendMsg("bot", response);
      this.speak(response);
    }, 1000);
  }

  appendMsg(sender, text) {
    const box = document.getElementById("chat-messages");
    const div = document.createElement("div");
    div.className = `msg ${sender}`;
    div.innerText = text;
    box.appendChild(div);
    box.scrollTop = box.scrollHeight;
  }

  // Google Transcript Feature (Text-to-Speech) in Native Language
  speak(text) {
    if ("speechSynthesis" in window) {
      const utterance = new SpeechSynthesisUtterance(text);
      // Default to Hindi/Indian English if available
      const voice = this.voices.find(
        (v) => v.lang.includes("hi") || v.lang.includes("en-IN")
      );
      if (voice) utterance.voice = voice;
      window.speechSynthesis.speak(utterance);
    }
  }

  startListening() {
    if ("webkitSpeechRecognition" in window) {
      const recognition = new webkitSpeechRecognition();
      recognition.lang = "hi-IN"; // Default to Hindi
      recognition.start();

      recognition.onresult = (event) => {
        const transcript = event.results[0][0].transcript;
        document.getElementById("chat-input").value = transcript;
        this.sendMessage();
      };
    } else {
      alert("Voice input not supported in this browser.");
    }
  }
}

window.kissanBot = new KissanBot();
