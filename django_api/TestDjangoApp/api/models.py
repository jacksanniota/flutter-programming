from django.db import models
from django.utils import timezone
from django.contrib.auth.models import User

class UserPosting(models.Model):
    poster = models.ForeignKey(User, on_delete=models.CASCADE)
    message = models.TextField(blank=True, null=False)
    created_date = models.DateTimeField(default=timezone.now, null=False)
    vote_count = models.IntegerField(default=0, null=False)
    location_lat = models.FloatField(null=False)
    location_long = models.FloatField(null=False)

    def upvote(self):
        self.vote_count = self.vote_count + 1
        self.save()

    def downvote(self):
        self.vote_count = self.vote_count - 1
        self.save()

    def __str__(self):
        created_date = timezone.localtime(self.created_date).strftime("%m/%d/%Y %I:%M")
        return self.poster.username + " posted: " + self.message + " at " + str(created_date)


