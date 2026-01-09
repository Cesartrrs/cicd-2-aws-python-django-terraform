from django.contrib import admin
from django.urls import path
from django.http import JsonResponse

def home(request):
    return JsonResponse({"message": "Hello from Django"})

urlpatterns = [
    path("", home),
    path("admin/", admin.site.urls),
]
