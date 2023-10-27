from flask import Blueprint, render_template,request,redirect, url_for, session
from app.models import get_orders, make_payment, get_table_order
import pandas as pd


payment_bp = Blueprint('payment', __name__)

@payment_bp.route('/payment')
def payment():
    current_open_orders = get_orders('open')

    table_numbers = set()
    for order in current_open_orders:
        table_numbers.add(order['table_id'])

    table_numbers = list(table_numbers)
    table_numbers.sort()

    #Find totals
    totals = {}
    for table_number in table_numbers:
        _, total_cost = get_table_order(table_number)
        totals[table_number] = total_cost

    session['totals'] = totals

    return render_template('payment.html',
                           open_orders = current_open_orders,
                           table_numbers = table_numbers,
                           totals = totals)


@payment_bp.route('/pay-total', methods=['POST'])
def pay_total(): 
    table_id = request.form.get('table_id')
    session['table_id'] = table_id
    
    print(table_id)
    make_payment(table_id=table_id)

    # Redirect to the payment confirmation page
    return redirect(url_for('payment.payment_confirmation'))

@payment_bp.route('/payment-confirmation')
def payment_confirmation():
    # Retrieve the data from session
    table_id = session.get('table_id')

    total_amount = session.get('totals')[table_id]
    

    # Clear the session data to avoid keeping unnecessary information
    session.pop('totals', None)
    session.pop('table_id', None)


    return render_template('payment-confirmation.html',
                           total_amount= f'£{total_amount:.2f}',
                           table_id=table_id)