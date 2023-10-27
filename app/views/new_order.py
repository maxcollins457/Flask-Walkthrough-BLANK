from flask import Blueprint, render_template, request, jsonify
from app.models import get_menu_items, place_order, get_tables_numbers, course_name_filter

new_order_bp = Blueprint('new_order', __name__)

@new_order_bp.route('/new-order')
def new_order():
    _,_,_, menu_courses, _ = get_menu_items()
    course_names = list(set(menu_courses))

    menu_data = course_name_filter(course_names)

    
    table_numbers = get_tables_numbers()

    return render_template('new-order.html',
                           menu_data=menu_data,
                           table_numbers = table_numbers)

@new_order_bp.route('/confirm_order', methods=['POST'])
def confirm_order():
    order_data = request.get_json()
    
    # Extract item_ids, table_number, and comments from the nested dictionary
    item_data = order_data.get('items', [])
    table_name = order_data.get('tableNumber')

    # Extract item details including comments
    item_ids = [item['id'] for item in item_data]


    table_number = int(table_name.split(' ')[-1])
    # Here, you can process the confirmed order as needed

    place_order(item_ids, table_number)
    return jsonify({"message": "Order confirmed successfully!"})