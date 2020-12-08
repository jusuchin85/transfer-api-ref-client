FROM python:3

LABEL author="Justin Alex Paramanandan"
LABEL email="me@justinalex.com"
LABEL release-date="2020-12-08"
LABEL git_commit=$GIT_COMMIT

ARG MAIN_DIR=/opt/app
ARG UPLOAD_DIR=/upload
ARG GIT_COMMIT=''

# Create required directories
RUN mkdir ${MAIN_DIR} \
    && mkdir ${UPLOAD_DIR}

# Copy Python library requirements file
COPY requirements.txt ${MAIN_DIR}

# Copy source codes for script to function
COPY src/* ${MAIN_DIR}/src/

# Copy all tests codes - for testing
COPY tests/utils/mock_response.py ${MAIN_DIR}/tests/utils/
COPY tests/test_file_service.py ${MAIN_DIR}/tests/
COPY tests/test_file_uploader.py ${MAIN_DIR}/tests/

# Copy main script
COPY app.py ${MAIN_DIR}

# Set the directory to work on
WORKDIR ${MAIN_DIR}

# Install required libraries and run unit testing to ensure that everything's good
RUN pip install -r ${MAIN_DIR}/requirements.txt \
    && python -m unittest ${MAIN_DIR}/tests/*.py -v

CMD [ "python", "./app.py" ]
