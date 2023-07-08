from rest_framework import serializers
from .models import UserQuizList


class UserQuizListSerializer(serializers.ModelSerializer):

    class Meta:
        model = UserQuizList
        fields = ['id', 'user', 'name', 'sign_ids', 'last_practiced', 'last_sign_index']

    def to_internal_value(self, data):
        sign_ids = data.get('sign_ids', '')
        if sign_ids:
            data['sign_ids'] = ','.join(str(i) for i in sign_ids)
        internal_value = super().to_internal_value(data)
        return internal_value

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        sign_ids = representation.get('sign_ids', '')
        if sign_ids:
            representation['sign_ids'] = [int(char) for char in sign_ids.split(',')]
        return representation
