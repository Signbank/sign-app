from rest_framework import serializers
from .models import UserSignList, SignList, Sign


class SignSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sign
        fields = ['name', 'video_url', 'image_url']


class SignListSerializer(serializers.ModelSerializer):
    signs = SignSerializer(many=True)

    class Meta:
        model = SignList
        fields = ['name', 'signs']


class UserSignListSerializer(serializers.ModelSerializer):
    sign_list = SignListSerializer()

    class Meta:
        model = UserSignList
        fields = ['id', 'user', 'sign_list', 'last_practiced', 'last_sign_index']

    def create(self, validated_data):
        quiz_list = validated_data.pop('sign_list')
        signs_data = quiz_list.pop('signs')
        signs = [Sign(**item) for item in signs_data]
        Sign.objects.bulk_create(signs)

        sign_list = SignList.objects.create(**quiz_list)
        sign_list.signs.set(signs)

        user_sign_list = UserSignList.objects.create(sign_list=sign_list, **validated_data)
        return user_sign_list
