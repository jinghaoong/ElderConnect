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

    path('blood-pressure/', views.BPListView.as_view(), name='bp'),
    path('blood-pressure/<int:pk>/', views.BPDetailView.as_view(), name='bp-detail'),
    path('blood-pressure/new/', views.BPCreateView.as_view(), name='bp-create'),
    path('blood-pressure/<int:pk>/update/', views.BPUpdateView.as_view(), name='bp-update'),
    path('blood-pressure/<int:pk>/delete/', views.BPDeleteView.as_view(), name='bp-delete'),
]
