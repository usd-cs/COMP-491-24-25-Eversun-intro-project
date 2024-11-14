from models import User, Post, Comment

import secrets

#def test_user_pass_hash(mocker):
    #mocker.patch('secrets.token_hex')
    #secrets.token_hex.return_value = "aaaaaaaaaaaaaaaa"
    #correct_salted_password = "aaaaaaaapasswordaaaaaaaa"
    

import pytest
from unittest.mock import MagicMock
from datetime import datetime
from models import User, Post, Comment


@pytest.fixture
def user_data():
    return {
        "email": "test@example.com",
        "name": "Test User",
        "admin": False,
        "password_plaintext": "securepassword"
    }


@pytest.fixture
def post_data():
    return {
        "contents": "This is a test post.",
        "user_id": 1,
        "created_at": datetime(2024, 1, 1, 12, 0, 0)
    }


@pytest.fixture
def comment_data():
    return {
        "contents": "This is a test comment.",
        "user_id": 1,
        "post_id": 1,
        "created_at": datetime(2024, 1, 1, 12, 0, 0)
    }


# 1. Test User Model Initialization
def test_user_initialization(user_data):
    user = User(**user_data)
    assert user.email == user_data["email"]
    assert user.name == user_data["name"]
    assert user.admin == user_data["admin"]
    assert len(user.password) == 80  # 16 bytes for salt + 64 bytes for SHA-256 hash


# 2. Test Password Hashing and Checking
def test_user_password_hashing(user_data):
    user = User(**user_data)
    assert user.check_password("securepassword") is True
    assert user.check_password("wrongpassword") is False


# 3. Test Post Model Initialization and Serialization
def test_post_initialization(post_data):
    post = Post(**post_data)
    assert post.contents == post_data["contents"]
    assert post.user_id == post_data["user_id"]
    assert post.created_at == post_data["created_at"]

def test_post_to_json(post_data):
    post = Post(**post_data)
    post_json = post.to_json()
    assert '"contents": "This is a test post."' in post_json
    assert '"user_id": 1' in post_json
    assert '"created_at": "2024-01-01 12:00:00"' in post_json


# 4. Test Comment Model Initialization and Serialization
def test_comment_initialization(comment_data):
    comment = Comment(**comment_data)
    assert comment.contents == comment_data["contents"]
    assert comment.user_id == comment_data["user_id"]
    assert comment.post_id == comment_data["post_id"]
    assert comment.created_at == comment_data["created_at"]

def test_comment_to_json(comment_data):
    comment = Comment(**comment_data)
    comment_json = comment.to_json()
    assert '"contents": "This is a test comment."' in comment_json
    assert '"user_id": 1' in comment_json
    assert '"post_id": 1' in comment_json
    assert '"created_at": "2024-01-01 12:00:00"' in comment_json

