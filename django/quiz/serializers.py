from rest_framework import serializers
from .models import UserQuizList, QuizList, Sign


class SignSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sign
        fields = ['sign_name', 'video_url', 'image_url']


class QuizListSerializer(serializers.ModelSerializer):
    signs = SignSerializer(many=True)

    class Meta:
        model = QuizList
        fields = ['id', 'name', 'signs']


class UserQuizListSerializer(serializers.ModelSerializer):
    quiz_list = QuizListSerializer()

    class Meta:
        model = UserQuizList
        fields = ['id', 'user', 'quiz_list', 'last_practiced', 'last_sign_index']

    def create(self, validated_data):
        quiz_list_data = validated_data.pop('quiz_list')
        signs_data = quiz_list_data.pop('signs')
        signs = [Sign(**item) for item in signs_data]
        Sign.objects.bulk_create(signs)

        quiz_list = QuizList.objects.create(**quiz_list_data)
        quiz_list.signs.set(signs)

        user_sign_list = UserQuizList.objects.create(quiz_list=quiz_list, **validated_data)
        return user_sign_list
