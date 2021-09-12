from django.urls import path, include
from . import views

urlpatterns = [
    path('test', views.test_api, name='test'),
    path('register', views.register_user, name='register-user'),
    path('login', views.login_user, name='login-user'),
    path('posting/create', views.create_user_posting, name='create-posting'),
    path('postings/all', views.get_all_user_postings, name='get-postings'),
    path('posting/upvote', views.upvote_posting, name='upvote-posting'),
    path('posting/downvote', views.downvote_posting, name='downvote-posting'),
    path('posting', views.get_posting, name='get-posting'),
]
