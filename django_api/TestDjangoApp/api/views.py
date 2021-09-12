from .models import UserPosting
from django.http.response import JsonResponse
from django.http import HttpResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from django.views.decorators.csrf import csrf_exempt
from django.utils import timezone

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
            'pk' : user.pk,
            'username' : user.username,
            'email' : user.email,
            'first_name' : user.first_name,
            'last_name' : user.last_name
        }, status=201)
    else:
        return HttpResponse(status=400)

# API Endpoint to login a user
# Takes in username, password
# Returns the user as a json response
@csrf_exempt
def login_user(request):
    if request.method == "POST" and 'username' in request.POST and 'password' in request.POST:
        user = authenticate(username=request.POST['username'], password=request.POST['password'])
        if user is not None:
            return JsonResponse({
                'pk' : user.pk,
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
        return HttpResponse(status=400)

# API Endpoint to create a posting
# Other users can see and vote on postings
# Takes in posting user's primary key, message, the lat and long of the posting user's location
# Returns the posting
@csrf_exempt
def create_user_posting(request):
    if request.method == "POST" and 'user_pk' in request.POST and 'message' in request.POST and request.POST['message'] != '' and 'lat' in request.POST and 'long' in request.POST:
        try:
            user = User.objects.get(pk=request.POST['user_pk'])
        except User.DoesNotExist:
            return HttpResponse(status=400)
        posting = UserPosting.objects.create(poster=user, message=request.POST['message'], location_lat=request.POST['lat'], location_long=request.POST['long'])
        return JsonResponse({
            'pk' : posting.pk,
            'poster' : posting.poster.pk,
            'message' : posting.message,
            'created_date' : timezone.localtime(posting.created_date).strftime("%m/%d/%Y %I:%M"),
            'vote_count' : posting.vote_count,
            'lat' : float(posting.location_lat),
            'long' : float(posting.location_long),
        }, status=201)
    else:
        return HttpResponse(status=400)

# API Endpoint to get all of the user postings
# Takes in nothing, returns a list of the user postings
@csrf_exempt
def get_all_user_postings(request):
    if request.method == "GET":
        user_postings = UserPosting.objects.all().order_by('-created_date')
        user_postings_json = list()
        for posting in user_postings:
            posting_json = {
                'pk' : posting.pk,
                'poster' : posting.poster.pk,
                'message' : posting.message,
                'created_date' : timezone.localtime(posting.created_date).strftime("%m/%d/%Y %I:%M"),
                'vote_count' : posting.vote_count,
                'lat' : posting.location_lat,
                'long' : posting.location_long,
            }
            user_postings_json.append(posting_json)
        return JsonResponse({
            'postings' : user_postings_json
        }, status=200)
    else:
        return HttpResponse(status=400)

# API Endpoint to upvote a user posting
# Upvotes the posting and returns the posting
@csrf_exempt
def upvote_posting(request):
    if request.method == "POST" and 'posting_pk' in request.POST:
        try:
            user_posting = UserPosting.objects.get(pk=request.POST['posting_pk'])
        except UserPosting.DoesNotExist:
            return HttpResponse(status=400)
        user_posting.upvote()
        return JsonResponse({
            'pk' : user_posting.pk,
            'poster' : user_posting.poster.pk,
            'message' : user_posting.message,
            'created_date' : timezone.localtime(user_posting.created_date).strftime("%m/%d/%Y %I:%M"),
            'vote_count' : user_posting.vote_count,
            'lat' : float(user_posting.location_lat),
            'long' : float(user_posting.location_long),
        }, status=200)
    else:
        return HttpResponse(status=400)

# API Endpoint to downvote a user posting
# Takes in posting_pk, the primary key of the posting
# Downvotes the posting and returns the posting
@csrf_exempt
def downvote_posting(request):
    if request.method == "POST" and 'posting_pk' in request.POST:
        try:
            user_posting = UserPosting.objects.get(pk=request.POST['posting_pk'])
        except UserPosting.DoesNotExist:
            return HttpResponse(status=400)
        user_posting.downvote()
        return JsonResponse({
            'pk' : user_posting.pk,
            'poster' : user_posting.poster.pk,
            'message' : user_posting.message,
            'created_date' : timezone.localtime(user_posting.created_date).strftime("%m/%d/%Y %I:%M"),
            'vote_count' : user_posting.vote_count,
            'lat' : float(user_posting.location_lat),
            'long' : float(user_posting.location_long),
        }, status=200)
    else:
        return HttpResponse(status=400)

# API Endpoint to get a user posting
# Takes in posting_pk, the primary key of the posting
# Returns the posting
@csrf_exempt
def get_posting(request):
    if request.method == "GET" and 'posting_pk' in request.GET:
        try:
            user_posting = UserPosting.objects.get(pk=request.GET['posting_pk'])
        except UserPosting.DoesNotExist:
            return HttpResponse(status=400)
        return JsonResponse({
            'pk' : user_posting.pk,
            'poster' : user_posting.poster.pk,
            'message' : user_posting.message,
            'created_date' : timezone.localtime(user_posting.created_date).strftime("%m/%d/%Y %I:%M"),
            'vote_count' : user_posting.vote_count,
            'lat' : float(user_posting.location_lat),
            'long' : float(user_posting.location_long),
        }, status=200)
    else:
        return HttpResponse(status=400)

