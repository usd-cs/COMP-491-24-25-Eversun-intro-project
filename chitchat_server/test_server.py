import pytest
from unittest.mock import MagicMock
from server import app
from models import db, User, Post

@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        with app.app_context():
            yield client


def test_sanity_check(client):
    response = client.get("/")
    assert response.status_code == 200
    assert response.data == b"This works"


def test_validate_user_success(client):
    
    user = User(
        email="test@example.com",
        name="Test user",
        admin=False,
        password_plaintext="password"
    )

    db.session.add(user)

    with client.session_transaction() as sess:
        response = client.post(
            "/v1/user/login", data={"email": "test@example.com", "password": "password"}
        )
    assert response.status_code == 200

    db.session.delete(user)


def test_validate_user_failure(client):

    response = client.post(
        "/v1/user/login", data={"email": "wrong@example.com", "password": "password"}
    )
    assert response.status_code == 403


def test_insert_single_post(client):
    with client.session_transaction() as sess:
        sess["user_id"] = 1

    response = client.post(
        "/v1/post/create", data={"content": "This is a new post"}
    )
    assert response.status_code == 200
    assert b"success" in response.data


def test_insert_single_comment(client):
    mock_comment = MagicMock()
    mock_comment.id = 1

    with client.session_transaction() as sess:
        sess["user_id"] = 1

    response = client.post(
        "/v1/post/1/comment/create", data={"content": "This is a new comment"}
    )
    assert response.status_code == 200
    assert b"success" in response.data


def test_get_one_post(client):
    mock_post = MagicMock()
    mock_post.to_json.return_value = '{"id": 1, "content": "Sample post"}'

    response = client.get("/v1/post/1")
    assert response.status_code == 200


def test_delete_single_post(client):
    with client.session_transaction() as sess:
        sess["is_admin"] = True

    response = client.delete("/v1/post/delete/1")
    assert response.status_code == 200
    assert b"success" in response.data
