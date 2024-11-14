import pytest
from unittest.mock import patch, MagicMock
from flask import session
import sqlalchemy     
from server import app


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


@patch("app.db.session")
def test_validate_user_success(mock_session, client):
    mock_user = MagicMock()
    mock_user.check_password.return_value = True
    mock_user.email = "test@example.com"
    mock_user.admin = False
    mock_user.id = 1
    mock_session.execute.return_value.scalar_one.return_value = mock_user

    with client.session_transaction() as sess:
        response = client.post(
            "/v1/user/login", data={"email": "test@example.com", "password": "password"}
        )
        
    assert response.status_code == 200
    assert session.get("email") == "test@example.com"
    assert session.get("is_admin") == False
    assert session.get("user_id") == 1


@patch("app.db.session")
def test_validate_user_failure(mock_session, client):
    mock_session.execute.side_effect = sqlalchemy.orm.exc.NoResultFound

    response = client.post(
        "/v1/user/login", data={"email": "wrong@example.com", "password": "password"}
    )
    assert response.status_code == 403


@patch("app.db.session")
def test_insert_single_post(mock_session, client):
    mock_post = MagicMock()
    mock_post.id = 1
    mock_session.add.return_value = None
    mock_session.commit.return_value = None
    mock_session.refresh.return_value = mock_post

    with client.session_transaction() as sess:
        sess["user_id"] = 1
    
    response = client.post(
        "/v1/post/create", data={"content": "This is a new post"}
    )
    assert response.status_code == 200
    assert b"success" in response.data


@patch("app.db.session")
def test_insert_single_comment(mock_session, client):
    mock_comment = MagicMock()
    mock_comment.id = 1
    mock_session.add.return_value = None
    mock_session.commit.return_value = None
    mock_session.refresh.return_value = mock_comment

    with client.session_transaction() as sess:
        sess["user_id"] = 1

    response = client.post(
        "/v1/post/1/comment/create", data={"content": "This is a new comment"}
    )
    assert response.status_code == 200
    assert b"success" in response.data


@patch("app.db.session")
def test_get_one_post(mock_session, client):
    mock_post = MagicMock()
    mock_post.to_json.return_value = '{"id": 1, "content": "Sample post"}'
    mock_session.execute.return_value.scalar_one.return_value = mock_post

    response = client.get("/v1/post/1")
    assert response.status_code == 200
    assert b"Sample post" in response.data


@patch("app.db.session")
def test_delete_single_post(mock_session, client):
    mock_post = MagicMock()
    mock_session.get_one.return_value = mock_post

    with client.session_transaction() as sess:
        sess["is_admin"] = True

    response = client.delete("/v1/post/delete/1")
    assert response.status_code == 200
    assert b"success" in response.data