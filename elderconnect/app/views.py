from django.shortcuts import render
from django.contrib.auth.mixins import LoginRequiredMixin, UserPassesTestMixin
from django.views.generic import (
    ListView,
    DetailView,
    CreateView,
    UpdateView,
    DeleteView
    )
from .models import Reminder, BloodPressure

def home(request):
    return render(request, 'app/home.html')


def about(request):
    return render(request, 'app/about.html', {'title': 'About Us'})


#REMINDER VIEWS
class ReminderListView(ListView):
    model = Reminder
    fields = ['title', 'date_current', 'time_1', 'time_2', 'time_3', 'time_4']
    template_name = 'app/reminders.html'
    context_object_name = 'reminders'
    paginate_by = 5
    
    # Get user's list of reminders
    def get_queryset(self):
        return Reminder.objects.filter(user=self.request.user).order_by('time_1')


class ReminderDetailView(DetailView):
    model = Reminder


class ReminderCreateView(LoginRequiredMixin, CreateView):
    model = Reminder
    fields = ['title', 'description', 'date_current', 'date_end', 
                'time_1', 'time_2', 'time_3', 'time_4', 'medicine_image']

    def form_valid(self, form):
        form.instance.user = self.request.user
        return super().form_valid(form)


class ReminderUpdateView(LoginRequiredMixin, UserPassesTestMixin, UpdateView):
    model = Reminder
    fields = ['title', 'date_current', 'date_end', 'time_1', 'time_2', 'time_3', 'time_4',
                 'medicine_image']

    def form_valid(self, form):
        form.instance.user = self.request.user
        return super().form_valid(form)

    def test_func(self):
        reminder = self.get_object()
        if self.request.user == reminder.user:
            return True
        return False


class ReminderDeleteView(LoginRequiredMixin, UserPassesTestMixin, DeleteView):
    model = Reminder
    success_url = '/reminders'

    def test_func(self):
        reminder = self.get_object()
        if self.request.user == reminder.user:
            return True
        return False


#BLOOD PRESSURE VIEWS
class BPListView(ListView):
    model = BloodPressure
    fields = ['title', 'date', 'time', 'systolic', 'diastolic']
    template_name = 'app/bloodpressure.html'
    context_object_name = 'bps'
    paginate_by = 5
    
    # Get user's list of blood pressure records
    def get_queryset(self):
        return BloodPressure.objects.filter(user=self.request.user).order_by('-date')


class BPDetailView(DetailView):
    model = BloodPressure


class BPCreateView(LoginRequiredMixin, CreateView):
    model = BloodPressure
    fields = ['title', 'comments', 'date', 'time', 'systolic', 'diastolic']

    def form_valid(self, form):
        form.instance.user = self.request.user
        return super().form_valid(form)


class BPUpdateView(LoginRequiredMixin, UserPassesTestMixin, UpdateView):
    model = BloodPressure
    fields = ['title', 'comments', 'date', 'time', 'systolic', 'diastolic']

    def form_valid(self, form):
        form.instance.user = self.request.user
        return super().form_valid(form)

    def test_func(self):
        bp = self.get_object()
        if self.request.user == bp.user:
            return True
        return False


class BPDeleteView(LoginRequiredMixin, UserPassesTestMixin, DeleteView):
    model = BloodPressure
    success_url = '/blood-pressure'

    def test_func(self):
        bp = self.get_object()
        if self.request.user == bp.user:
            return True
        return False
