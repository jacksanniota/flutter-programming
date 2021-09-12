from django.urls import path, include
from . import views

urlpatterns = [
    path('test', views.test_api, name='test'),
    path('register', views.register_user, name='register-user'),
    path('login', views.login_user, name='login-user'),
]
