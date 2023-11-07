FROM python:3.9.18

WORKDIR /code

COPY python3/requirements.txt ./
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt

COPY code /code

#CMD [ "python", "/code/ban-api/geocode.py" ]