# Misto Quest

Misto Quest is a mobile application designed to solve a common problem: people often don't know how to interestingly spend time in their own city, explore its unique culture, or support local businesses. Our platform motivates users to engage with their surroundings through interactive challenges and quests. It encourages the discovery of new places, participation in cultural events, and the promotion of local Ukrainian businesses.

Explore your city in a new way by solving puzzles and completing tasks at various real-world locations!

## ✨ Features

* **User Authentication:** Secure registration and login system using JWT.
* **Interactive Quest Feed:** Users can start quests, see their progress, and complete quests on their mobile devices.
* **Admin Panel:** A native dashboard for administrators to manage all quests on the platform.
* **Platform:** The Flutter frontend ensures a consistent experience on Android.

## 🛠️ Tech Stack

This project consists of a mobile frontend and a web backend.

* **Frontend (Mobile):**
    * [Flutter](https://flutter.dev/)
    * [Dart](https://dart.dev/)
* **Backend:**
    * [Python](https://www.python.org/)
    * [Django](https://www.djangoproject.com/)
    * [Django REST Framework](https://www.django-rest-framework.org/) for the REST API.
    * [PostgreSQL](https://www.postgresql.org/) for the database.
    * [Simple JWT](https://django-rest-framework-simplejwt.readthedocs.io/) for JSON Web Token authentication.

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

* [Python](https://www.python.org/downloads/) & [Pip](https://pip.pypa.io/en/stable/installation/)
* [Flutter SDK](https://docs.flutter.dev/get-started/install)
* [PostgreSQL](https://www.postgresql.org/download/) installed and running.

### Installation & Setup

The setup is divided into two parts: the backend server and the frontend mobile application.

#### 1. Backend (Django) Setup

1.  **Clone the repository and navigate to the backend directory:**
    ```sh
    git clone [https://github.com/ViktoriiaHudym/misto-quest.git](https://github.com/ViktoriiaHudym/misto-quest.git)
    cd misto-quest/mistoquest_backend 
    ```
    
2.  **Create a virtual environment and install dependencies:**
    ```sh
    python -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate`
    pip install -r requirements.txt
    ```

3.  **Set up Backend Environment Variables:**
    In a `settings.py` file in the `mistoquest_backend` directory add the necessary configuration for your database and Django settings:
    ```ini
    # mistoquest_backend/settings.py
    
    SECRET_KEY='your-django-secret-key'
    DEBUG=True
    
    # PostgreSQL Database Configuration
    DB_NAME='misto_quest_db'
    DB_USER='your_db_user'
    DB_PASSWORD='your_db_password'
    DB_HOST='localhost'
    DB_PORT='5432'
    ```

4.  **Run database migrations:**
    ```sh
    python manage.py migrate
    ```

#### 2. Frontend (Flutter) Setup

1.  **Navigate to the frontend directory:**
    ```sh
    cd ../mistoquest_frontend 
    ```

2.  **Get Flutter packages:**
    ```sh
    flutter pub get
    ```

### Running the Application

You need to run both the backend and frontend services separately.

1.  **Start the Django Backend Server:**
    In the `root` directory terminal:
    ```sh
    python manage.py runserver
    ```
    The backend API will be available at `http://127.0.0.1:8000`.

2.  **Run the Flutter App:**
    In the `mistoquest_frontend` directory terminal, with a simulator running or a device connected:
    ```sh
    flutter run
    ```
    The application will launch on your selected device/simulator and will connect to the local backend API.
