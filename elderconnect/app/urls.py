from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='app-home'),
    path('about/', views.about, name='app-about'),
    path('reminders/', views.ReminderListView.as_view(), name='reminders'),
    path('reminders/<int:pk>/', views.ReminderDetailView.as_view(), name='reminder-detail'),
    path('reminders/new/', views.ReminderCreateView.as_view(), name='reminder-create'),
    path('reminders/<int:pk>/update/', views.ReminderUpdateView.as_view(), name='reminder-update'),
    path('reminders/<int:pk>/delete/', views.ReminderDeleteView.as_view(), name='reminder-delete'),
]
