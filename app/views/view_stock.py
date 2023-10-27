from flask import Blueprint, render_template
from app.models import get_stock, restock ,calculate_low_stock_ingredients

view_stock_bp = Blueprint('view_stock', __name__)

@view_stock_bp.route('/view-stock')
def view_stock():
    current_stock = get_stock()

    low_stock_ingredients = calculate_low_stock_ingredients(current_stock)

    return render_template('view-stock.html',
                           stock_data = current_stock,
                           low_stock_ingredients=low_stock_ingredients)


@view_stock_bp.route('/restock')
def restock_endpoint():
    restock()  # Call the restock function
    return "Stock restock initiated"  # You can return any response you prefer
