# MediPrescribe API Documentation

## 1. Overview

This document defines the backend API contract for the MediPrescribe application based on the current product scenario:

- Role-based healthcare app for doctors and patients
- Doctor creates and manages prescriptions
- Patient views prescription history and profile information
- Medicine search and suggestion flow during prescription creation
- Notification system for new prescription updates and reminders

The current application architecture is built around repository interfaces and mock implementations, so this API design follows the same domain model and business flows already present in the app.

---

## 2. System Context

### Primary Users

1. Doctor
   - Authenticates with email and password
   - Manages patient records
   - Creates prescriptions with medicines and instructions
   - Reviews prescription history
   - Sends prescription updates / follow-up plans

2. Patient
   - Authenticates with email and password
   - Views prescriptions received from doctors
   - Checks medical details and medication instructions
   - Reviews profile and notification updates

### Core Entities

- User
- Doctor
- Patient
- Medicine
- Prescription
- PrescribedMedicine
- Notification

---

## 3. API Conventions

### Base URL

```http
https://api.mediprescribe.com/api/v1
```

### Authentication

All protected endpoints require a bearer token:

```http
Authorization: Bearer <access_token>
```

### Response Format

```json
{
  "success": true,
  "data": {},
  "message": "Operation successful",
  "error": null
}
```

### Error Format

```json
{
  "success": false,
  "data": null,
  "message": "Validation failed",
  "error": {
    "code": "VALIDATION_ERROR",
    "details": [
      {
        "field": "email",
        "message": "Email is required"
      }
    ]
  }
}
```

### Common HTTP Status Codes

- 200 OK — Successful request
- 201 Created — Resource created successfully
- 400 Bad Request — Invalid request payload
- 401 Unauthorized — Missing or invalid token
- 403 Forbidden — User does not have required permissions
- 404 Not Found — Resource not found
- 409 Conflict — Duplicate data
- 422 Unprocessable Entity — Business validation error
- 500 Internal Server Error — Server issue

---

## 4. Authentication APIs

### 4.1 Login

#### POST /auth/login

Authenticates a user and returns a token plus user profile.

Request body:

```json
{
  "email": "rajesh.kumar@hospital.com",
  "password": "password123",
  "role": "doctor"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "doc_001",
      "name": "Dr. Rajesh Kumar",
      "email": "rajesh.kumar@hospital.com",
      "phone": "+91 9876543210",
      "role": "doctor",
      "registrationNumber": "REG-1001",
      "specialization": "General Medicine"
    }
  },
  "message": "Login successful"
}
```

---

### 4.2 Doctor Registration

#### POST /auth/register/doctor

Request body:

```json
{
  "name": "Dr. Priya Sharma",
  "email": "priya.sharma@hospital.com",
  "phone": "+91 9988776655",
  "password": "password123",
  "registrationNumber": "REG-1002",
  "specialization": "Cardiology"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": "doc_002",
    "name": "Dr. Priya Sharma",
    "email": "priya.sharma@hospital.com",
    "phone": "+91 9988776655",
    "role": "doctor",
    "registrationNumber": "REG-1002",
    "specialization": "Cardiology"
  },
  "message": "Doctor registered successfully"
}
```

---

### 4.3 Patient Registration

#### POST /auth/register/patient

Request body:

```json
{
  "name": "Amit Singh",
  "email": "amit.singh@email.com",
  "phone": "+91 9123456780",
  "password": "password123",
  "dateOfBirth": "1995-06-15T00:00:00Z",
  "gender": "male",
  "bloodGroup": "O+",
  "address": "B-24, Green Park, New Delhi"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": "pat_001",
    "name": "Amit Singh",
    "email": "amit.singh@email.com",
    "phone": "+91 9123456780",
    "role": "patient",
    "dateOfBirth": "1995-06-15T00:00:00Z",
    "gender": "male",
    "bloodGroup": "O+",
    "address": "B-24, Green Park, New Delhi"
  },
  "message": "Patient registered successfully"
}
```

---

### 4.4 Forgot Password

#### POST /auth/forgot-password

Request body:

```json
{
  "email": "amit.singh@email.com"
}
```

Response:

```json
{
  "success": true,
  "data": null,
  "message": "Password reset link sent successfully"
}
```

---

## 5. Doctor APIs

### 5.1 Get Doctor Profile

#### GET /doctors/{doctorId}

Response:

```json
{
  "success": true,
  "data": {
    "id": "doc_001",
    "name": "Dr. Rajesh Kumar",
    "email": "rajesh.kumar@hospital.com",
    "phone": "+91 9876543210",
    "role": "doctor",
    "registrationNumber": "REG-1001",
    "specialization": "General Medicine"
  }
}
```

---

### 5.2 List Doctor Patients

#### GET /doctors/{doctorId}/patients

Query parameters:

- search (optional)
- page (optional)
- limit (optional)

Response:

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "pat_001",
        "name": "Amit Singh",
        "email": "amit.singh@email.com",
        "phone": "+91 9123456780",
        "role": "patient",
        "dateOfBirth": "1995-06-15T00:00:00Z",
        "gender": "male",
        "bloodGroup": "O+",
        "age": 30
      }
    ],
    "page": 1,
    "limit": 20,
    "total": 10
  }
}
```

---

### 5.3 Create Patient Record

#### POST /doctors/{doctorId}/patients

Request body:

```json
{
  "name": "Neha Verma",
  "email": "neha.verma@email.com",
  "phone": "+91 9898989898",
  "dateOfBirth": "1998-01-20T00:00:00Z",
  "gender": "female",
  "bloodGroup": "A+",
  "address": "Sector 15, Noida"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": "pat_010",
    "name": "Neha Verma",
    "email": "neha.verma@email.com",
    "phone": "+91 9898989898",
    "role": "patient",
    "dateOfBirth": "1998-01-20T00:00:00Z",
    "gender": "female",
    "bloodGroup": "A+",
    "address": "Sector 15, Noida"
  },
  "message": "Patient added successfully"
}
```

---

## 6. Patient APIs

### 6.1 Get Patient Profile

#### GET /patients/{patientId}

Response:

```json
{
  "success": true,
  "data": {
    "id": "pat_001",
    "name": "Amit Singh",
    "email": "amit.singh@email.com",
    "phone": "+91 9123456780",
    "role": "patient",
    "dateOfBirth": "1995-06-15T00:00:00Z",
    "gender": "male",
    "bloodGroup": "O+",
    "address": "B-24, Green Park, New Delhi",
    "age": 30
  }
}
```

---

### 6.2 List Patient Prescriptions

#### GET /patients/{patientId}/prescriptions

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": "pres_001",
      "doctorId": "doc_001",
      "patientId": "pat_001",
      "date": "2026-08-28T10:30:00Z",
      "diagnosis": "Seasonal flu with mild fever",
      "symptoms": "Fever, cough, body ache",
      "status": "sent",
      "followUpDate": "2026-09-04T00:00:00Z",
      "medicines": [
        {
          "id": "pm_001",
          "medicine": {
            "id": "med_001",
            "name": "Paracetamol",
            "genericName": "Acetaminophen",
            "strength": "500mg",
            "form": "tablet"
          },
          "dose": "1",
          "frequency": "twiceDaily",
          "duration": "5 days",
          "instructions": ["afterFood", "withWater"],
          "additionalNotes": "Take only if fever persists"
        }
      ]
    }
  ]
}
```

---

## 7. Medicine APIs

### 7.1 Search Medicines

#### GET /medicines/search

Query parameters:

- q: search text (required)
- limit: optional

Example:

```http
GET /medicines/search?q=par&limit=10
```

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": "med_001",
      "name": "Paracetamol",
      "genericName": "Acetaminophen",
      "strength": "500mg",
      "form": "tablet"
    },
    {
      "id": "med_002",
      "name": "Paracip",
      "genericName": "Acetaminophen",
      "strength": "650mg",
      "form": "tablet"
    }
  ]
}
```

---

### 7.2 Get Medicine Details

#### GET /medicines/{medicineId}

Response:

```json
{
  "success": true,
  "data": {
    "id": "med_003",
    "name": "Amoxicillin",
    "genericName": "Amoxicillin Trihydrate",
    "strength": "250mg",
    "form": "capsule"
  }
}
```

---

## 8. Prescription APIs

### 8.1 Create Prescription

#### POST /prescriptions

Request body:

```json
{
  "doctorId": "doc_001",
  "patientId": "pat_001",
  "diagnosis": "Upper respiratory infection",
  "symptoms": "Cough, sore throat, mild fever",
  "notes": "Monitor for 3 days; revisit if symptoms worsen",
  "followUpDate": "2026-09-05T00:00:00Z",
  "status": "draft",
  "medicines": [
    {
      "medicineId": "med_001",
      "dose": "1",
      "frequency": "twiceDaily",
      "duration": "5 days",
      "instructions": ["afterFood", "withWater"],
      "additionalNotes": "Take after breakfast and dinner"
    },
    {
      "medicineId": "med_003",
      "dose": "1",
      "frequency": "onceDaily",
      "duration": "5 days",
      "instructions": ["beforeFood"],
      "additionalNotes": "Complete the full course"
    }
  ]
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": "pres_010",
    "doctorId": "doc_001",
    "patientId": "pat_001",
    "date": "2026-09-03T09:15:00Z",
    "diagnosis": "Upper respiratory infection",
    "symptoms": "Cough, sore throat, mild fever",
    "notes": "Monitor for 3 days; revisit if symptoms worsen",
    "followUpDate": "2026-09-05T00:00:00Z",
    "status": "draft",
    "medicines": [
      {
        "id": "pm_010",
        "medicine": {
          "id": "med_001",
          "name": "Paracetamol",
          "genericName": "Acetaminophen",
          "strength": "500mg",
          "form": "tablet"
        },
        "dose": "1",
        "frequency": "twiceDaily",
        "duration": "5 days",
        "instructions": ["afterFood", "withWater"],
        "additionalNotes": "Take after breakfast and dinner"
      }
    ]
  },
  "message": "Prescription created successfully"
}
```

---

### 8.2 Get Prescription Details

#### GET /prescriptions/{prescriptionId}

Response:

```json
{
  "success": true,
  "data": {
    "id": "pres_001",
    "doctorId": "doc_001",
    "patientId": "pat_001",
    "date": "2026-08-28T10:30:00Z",
    "diagnosis": "Seasonal flu with mild fever",
    "symptoms": "Fever, cough, body ache",
    "notes": "Rest and hydration recommended",
    "followUpDate": "2026-09-04T00:00:00Z",
    "status": "sent",
    "medicines": [
      {
        "id": "pm_001",
        "medicine": {
          "id": "med_001",
          "name": "Paracetamol",
          "genericName": "Acetaminophen",
          "strength": "500mg",
          "form": "tablet"
        },
        "dose": "1",
        "frequency": "twiceDaily",
        "duration": "5 days",
        "instructions": ["afterFood", "withWater"],
        "additionalNotes": "Take only if fever persists"
      }
    ]
  }
}
```

---

### 8.3 Update Prescription

#### PUT /prescriptions/{prescriptionId}

Request body:

```json
{
  "diagnosis": "Respiratory infection improved",
  "status": "completed",
  "notes": "Patient responded well to treatment",
  "followUpDate": "2026-09-12T00:00:00Z"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": "pres_001",
    "status": "completed"
  },
  "message": "Prescription updated successfully"
}
```

---

### 8.4 List Prescriptions by Doctor

#### GET /prescriptions

Query parameters:

- doctorId (optional)
- patientId (optional)
- status (optional)
- fromDate (optional)
- toDate (optional)

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": "pres_001",
      "doctorId": "doc_001",
      "patientId": "pat_001",
      "date": "2026-08-28T10:30:00Z",
      "diagnosis": "Seasonal flu with mild fever",
      "status": "sent"
    }
  ]
}
```

---

## 9. Notification APIs

### 9.1 Get User Notifications

#### GET /notifications

Query parameters:

- userId (required)
- unreadOnly (optional)

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": "not_001",
      "userId": "pat_001",
      "title": "New prescription received",
      "message": "Dr. Rajesh Kumar has sent a new prescription.",
      "type": "prescription",
      "isRead": false,
      "createdAt": "2026-09-03T08:45:00Z"
    }
  ]
}
```

---

### 9.2 Mark Notification as Read

#### PATCH /notifications/{notificationId}/read

Response:

```json
{
  "success": true,
  "data": {
    "id": "not_001",
    "isRead": true
  },
  "message": "Notification marked as read"
}
```

---

## 10. Domain Model Mapping

This API design follows the current app models:

### User

```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "phone": "string",
  "role": "doctor | patient"
}
```

### Doctor

```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "phone": "string",
  "role": "doctor",
  "registrationNumber": "string",
  "specialization": "string"
}
```

### Patient

```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "phone": "string",
  "role": "patient",
  "dateOfBirth": "ISO date",
  "gender": "male | female | other",
  "bloodGroup": "string",
  "address": "string"
}
```

### Medicine

```json
{
  "id": "string",
  "name": "string",
  "genericName": "string",
  "strength": "string",
  "form": "tablet | capsule | syrup | injection | ointment | powder | liquid"
}
```

### PrescribedMedicine

```json
{
  "id": "string",
  "medicine": "Medicine",
  "dose": "string",
  "frequency": "onceDaily | twiceDaily | threeTimesDaily | every8Hours | sos",
  "duration": "string",
  "instructions": ["beforeFood", "afterFood", "atBedtime", "withWater", "asNeeded"],
  "additionalNotes": "string"
}
```

### Prescription

```json
{
  "id": "string",
  "doctorId": "string",
  "patientId": "string",
  "date": "ISO date",
  "diagnosis": "string",
  "symptoms": "string",
  "medicines": ["PrescribedMedicine"],
  "notes": "string",
  "followUpDate": "ISO date",
  "status": "draft | sent | completed"
}
```

---

## 11. Business Rules

- A doctor can create multiple prescriptions for a patient.
- A patient can receive prescriptions from multiple doctors.
- Each prescription contains one or more medicines.
- Each medicine entry contains dose, frequency, duration, and administration instructions.
- Prescription status can move from draft to sent to completed.
- Notifications are generated when a prescription is created and sent.
- Medicine suggestions should support dynamic search by medicine name or generic name.

---

## 12. Security Considerations

- Use HTTPS only
- Protect all endpoints with JWT-based authentication
- Use role-based authorization for doctor and patient routes
- Validate patient ownership before exposing prescription details
- Prevent unauthorized access to another doctor’s patient records
- Sanitize all input values before persistence

---

## 13. Assumptions for Current App Scenario

This API specification is designed for the current mock-data application scenario, not a production clinical system. It assumes:

- The app currently uses repositories and mock services for local data simulation.
- Data is not yet connected to a real database or external backend.
- Medicine suggestions are search-based and not generated by a medical intelligence engine.
- Authentication is implemented in demo mode with mock credentials.

---

## 14. Example End-to-End Flow

### Doctor creates a prescription

1. Doctor logs in using /auth/login
2.Doctor fetches patient list via /doctors/{doctorId}/patients
3. Doctor searches medicine using /medicines/search?q=par
4. Doctor submits prescription via POST /prescriptions
5. Prescription status may be saved as draft or sent
6. Patient receives a notification via /notifications
7. Patient retrieves prescription via /patients/{patientId}/prescriptions

---

## 15. Summary

This API documentation reflects the current MediPrescribe app behavior and data model. It provides a clean REST contract for:

- Authentication
- Doctor and patient management
- Medicine search and lookup
- Prescription creation and viewing
- Notification tracking

This API can later be implemented with a real backend using Node.js, Spring Boot, Firebase, or any other service while keeping the same domain structure.
