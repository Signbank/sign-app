# Generated by Django 4.1.2 on 2023-03-01 10:42

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('quiz', '0002_alter_sign_image_url_alter_sign_video_url'),
    ]

    operations = [
        migrations.RenameModel(
            old_name='SignList',
            new_name='QuizList',
        ),
        migrations.RenameModel(
            old_name='UserSignList',
            new_name='UserQuizList',
        ),
        migrations.RenameField(
            model_name='userquizlist',
            old_name='sign_list',
            new_name='quiz_list',
        ),
    ]