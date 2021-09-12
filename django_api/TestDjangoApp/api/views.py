from django.contrib import auth
from django.http.response import HttpResponseBadRequest, JsonResponse
from django.shortcuts import render
from django.http import HttpResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from django.views.decorators.csrf import csrf_exempt

# API Endpoint to ensure the API is running
def test_api(request):
    return HttpResponse("The API is loading!")

# API Endpoint to register a user
# Takes in username, email, password, first_name, last_name
# Returns the created user as a json response
@csrf_exempt
def register_user(request):
    if request.method == "POST" and 'username' in request.POST and request.POST['username'] != '' and 'email' in request.POST and request.POST['email'] != '' and 'password' in request.POST and request.POST['password'] != '' and 'first_name' in request.POST and request.POST['first_name'] != '' and 'last_name' in request.POST and request.POST['last_name'] != '':
        username = request.POST['username']
        email = request.POST['email']
        password = request.POST['password']
        first_name = request.POST['first_name']
        last_name = request.POST['last_name']
        user = User.objects.create_user(username, email, password)
        user.first_name = first_name
        user.last_name = last_name
        user.save()
        return JsonResponse({
            'username' : user.username,
            'email' : user.email,
            'first_name' : user.first_name,
            'last_name' : user.last_name
        }, status=201)
    else:
        raise HttpResponseBadRequest

# API Endpoint to login a user
# Takes in username, password
# Returns the user as a json response
@csrf_exempt
def login_user(request):
    if request.method == "POST" and 'username' in request.POST and 'password' in request.POST:
        user = authenticate(username=request.POST['username'], password=request.POST['password'])
        if user is not None:
            return JsonResponse({
                'username' : user.username,
                'email' : user.email,
                'first_name' : user.first_name,
                'last_name' : user.last_name
            }, status=200)
        else:
            return JsonResponse({
                'message' : 'The entered username and/or password is incorrect'
            }, status=401)
    else:
        raise HttpResponseBadRequest
