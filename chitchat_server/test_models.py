from models import User, Post, Comment

import secrets

def test_user_pass_hash(mocker):
    mocker.patch('secrets.token_hex')
    secrets.token_hex.return_value = "aaaaaaaaaaaaaaaa"
    correct_salted_password = "aaaaaaaapasswordaaaaaaaa"


