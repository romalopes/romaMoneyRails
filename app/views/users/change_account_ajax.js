//$("#history_of_transactions").html("<%= escape_javascript(render('transactions/transaction_history')) %>")
$("#verify_transactions").html("<%= escape_javascript(render('transactions/verify_transactions')) %>")

$("#account_list").html("<%= escape_javascript(render('shared/account_list')) %>")
$("#user_account_list").html("<%= escape_javascript(render('shared/user_account_list')) %>")
$("#account_balance").html("<%= escape_javascript(render('shared/account_balance')) %>")
$("#date_account").html("<%= escape_javascript(render('shared/date_account')) %>")
