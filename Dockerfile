# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8-alpine

EXPOSE 8000
ENV VAR1=10

ENV PATH="/Scripts:${PATH}"
ENV PATH="manage.py:${PATH}"

# Install pip requirements
COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache --virtual .tmp gcc libc-dev linux-headers
RUN python -m pip install -r /requirements.txt
RUN apk del .tmp

# Creating work directory
RUN mkdir /eventy
COPY ./ /eventy
WORKDIR /eventy
COPY ./Scripts /eventy/Script

# Change executable permission for scripts folder
RUN chmod +x /eventy/Scripts/*

# creating media and static directory in docker
RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1


# Switching to a non-root user, please refer to https://aka.ms/vscode-docker-python-user-rights
# TODO: entender melhor a criação de usuários e permissões
RUN adduser -D user && chown -R user /eventy
RUN chown -R user:user /vol
RUN chmod -R 755 /vol/web
USER user

# RUN echo 'alias manage="$VIRTUAL_ENV/../manage.py"' >> ~/.bashrc

CMD ["entrypoint.sh"]

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
# File wsgi.py was not found in subfolder: 'wttd_dock'. Please enter the Python path to wsgi file.
# CMD ["gunicorn", "--bind", "127.0.0.1:8000", "pythonPath.to.wsgi"]
