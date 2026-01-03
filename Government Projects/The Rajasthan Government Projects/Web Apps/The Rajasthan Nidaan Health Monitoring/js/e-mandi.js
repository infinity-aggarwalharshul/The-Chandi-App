/**
 * Raj Kissan e-Mandi System
 * Innovative Sales System for Organic Products
 */
class EMandiSystem {
  constructor() {
    this.products = [
      {
        id: 101,
        farmer: "Ram Lal",
        crop: "Organic Wheat",
        price: 2200,
        unit: "Qtl",
        rating: 4.5,
        reviews: 12,
        loc: "Kota",
      },
      {
        id: 102,
        farmer: "Sita Devi",
        crop: "Bajra (Millet)",
        price: 1800,
        unit: "Qtl",
        rating: 4.8,
        reviews: 8,
        loc: "Barmer",
      },
    ];
    this.cart = [];
  }

  // List products
  renderMarketplace(containerId) {
    const container = document.getElementById(containerId);
    if (!container) return;

    let html = '<div class="mandi-grid">';
    this.products.forEach((p) => {
      html += `
            <div class="mandi-card">
                <div class="mandi-img">🌾</div>
                <div class="mandi-info">
                    <h4>${p.crop}</h4>
                    <p>👨‍🌾 ${p.farmer} | 📍 ${p.loc}</p>
                    <div class="price">₹${p.price}/${p.unit}</div>
                    <div class="rating">⭐ ${p.rating} (${p.reviews} Reviews)</div>
                    <button class="btn-buy" onclick="window.eMandi.buy(${p.id})">Buy Now</button>
                    <button class="btn-feedback" onclick="window.eMandi.writeReview(${p.id})">Review</button>
                </div>
            </div>`;
    });
    html += "</div>";
    container.innerHTML = html;
  }

  buy(id) {
    const product = this.products.find((p) => p.id === id);
    if (
      confirm(`Confirm purchase of ${product.crop} from ${product.farmer}?`)
    ) {
      alert(
        "Order Placed via e-Mandi Secure Gateway! 🚚\nTracking ID: RK-ORD-" +
          Date.now()
      );
    }
  }

  writeReview(id) {
    const review = prompt("Write your feedback for this organic product:");
    if (review) {
      alert("Thank you! Your feedback helps other consumers.");
      // Logic to save review to Dhara-Kosh would go here
    }
  }
}

window.eMandi = new EMandiSystem();
