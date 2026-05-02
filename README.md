# Panel de Asistencia UAT

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-Web-02569B?logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Firestore%20%7C%20Storage-orange?logo=firebase&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Web-4CAF50)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

**Dashboard web para supervisión de asistencia docente, reportes en tiempo real y gestión de ciclos escolares en la UAT.**

</div>

---

## 📋 Descripción

Panel de Asistencia UAT es una aplicación web desarrollada en **Flutter para Web** que permite a los administradores académicos:

- Cargar ciclos escolares completos a partir de archivos Excel con horarios de profesores.
- Visualizar en **tiempo real** las inasistencias y reportes de los docentes.
- Gestionar y respaldar evidencias fotográficas de asistencia en la nube.
- Exportar datos y calendarios académicos.

Ideal para departamentos de Recursos Humanos Académicos, dirección de carrera o coordinaciones que necesitan una herramienta centralizada para monitorear la puntualidad del personal docente.

---

## 🚀 Características Principales

| Módulo | Descripción |
|--------|-------------|
| **📤 Carga de Ciclos Escolares** | Importa horarios masivos de profesores desde archivos Excel (.xlsx), parsea la información y construye el ciclo académico en Firestore. |
| **📊 Vista en Vivo (Faltas y Reportes)** | Panel dividido con **StreamBuilder** que muestra en tiempo real:<br>• Profesores que aún no han llegado a clase<br>• Reportes de incidencias enviados por docentes<br>• Notificaciones de escritorio automáticas cuando llegan nuevos registros |
| **📅 Calendario Académico** | Visualización semanal (Lunes-Viernes) con horarios de 7:00 a 21:00 hrs, mostrando bloques, aulas y materias asignadas. |
| **☁️ Respaldo en la Nube** | Almacenamiento de imágenes de asistencia en **Firebase Storage** con opciones de respaldo y liberación de espacio. |
| **💾 Persistencia Firebase** | Datos estructurados en **Cloud Firestore** (colecciones: `ciclos > profesores`, `inasistencias`, `reportes`). |
| **🔔 Notificaciones Nativas** | Alertas de escritorio mediante `quick_notify` cuando se detectan nuevas faltas o reportes. |

---

## 🛠️ Stack Tecnológico

| Tecnología | Uso |
|------------|-----|
| **Flutter (Web)** | Framework UI multiplataforma, desplegado como PWA/Web |
| **Dart** | Lenguaje de programación |
| **Firebase Core + Cloud Firestore** | Base de datos NoSQL en tiempo real para ciclos, profesores, inasistencias y reportes |
| **Firebase Storage** | Almacenamiento de evidencias fotográficas de asistencia |
| **Firebase App Check** | Protección contra abuso de APIs de Firebase |
| **Excel (dart package)** | Lectura y parseo de archivos `.xlsx` con horarios de profesores |
| **File Picker** | Selección de archivos Excel desde el navegador |
| **Universal HTML** | Operaciones de descarga de archivos en entorno web |
| **Get Storage** | Almacenamiento local ligero para conteo de notificaciones |
| **Quick Notify** | Notificaciones de escritorio nativas |
| **Archive** | Compresión de archivos para respaldos |
| **SN Progress Dialog** | Diálogos de progreso para operaciones pesadas |

---

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                          # Punto de entrada, inicializa Firebase
├── firebase_options.dart              # Configuración multiplataforma de Firebase
├── constantes/
│   └── bloques.dart                   # Constantes de bloques y horarios
├── controllers/
│   ├── archivo_controller.dart        # Lógica de lectura Excel y generación de mapas/calendario
│   ├── firestore_controller.dart      # Streams de Firestore (profesores, reportes, inasistencias)
│   └── storage_controller.dart        # Gestión de imágenes en Firebase Storage
├── views/
│   ├── home_page.dart                 # Pantalla principal: carga de ciclos, selección de archivo Excel, subida a Firestore
│   ├── ver_en_vivo_faltas_reportes_view.dart  # Panel en vivo con StreamBuilders y notificaciones
│   ├── calendario_view.dart           # Vista semanal de horarios y aulas
│   └── profesor_view.dart             # Detalle de profesores y aulas
└── widgets/
    └── dropdown_custom.dart           # Componente de selección de ciclo escolar
```

---

## 📦 Instalación y Ejecución

### Requisitos Previos

- Flutter SDK `>=3.0.0 <4.0.0` con soporte para Web habilitado
- Dart SDK compatible
- Cuenta de Firebase con proyecto configurado
- Navegador moderno (Chrome, Firefox, Edge)

### Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/ebravo-dev/panel-de-asistencia-uat.git
cd panel-de-asistencia-uat

# 2. Instalar dependencias
flutter pub get

# 3. Configurar Firebase
# Asegúrate de que tu proyecto Firebase esté vinculado.
# El archivo firebase_options.dart ya contiene la configuración web.
# Si usas un proyecto nuevo, ejecuta:
# flutterfire configure

# 4. Ejecutar en modo desarrollo web
flutter run -d chrome

# 5. Generar build de producción para web
flutter build web
```

### Notas de Configuración

- El parseo del archivo Excel espera un formato específico de horarios de la UAT (filas a partir de la 7, columnas definidas).
- Las notificaciones de escritorio requieren permisos del navegador.

---

## 📱 Flujo de Uso

1. **Seleccionar Ciclo Escolar:** Elige el periodo académico desde el dropdown.
2. **Cargar Archivo Excel:** Selecciona el archivo de horarios de profesores proporcionado por la universidad.
3. **Construir Ciclo:** El sistema parsea el Excel, genera el mapa de profesores y el calendario académico.
4. **Subir a Firestore:** Almacena toda la información en la nube para su consulta en tiempo real.
5. **Monitorear en Vivo:** Accede a la vista de faltas y reportes para ver en tiempo real qué profesores no han llegado y qué incidencias se han reportado.
6. **Gestionar Evidencias:** Respaldar o liberar las imágenes de asistencia almacenadas en Firebase Storage.

---

## 🗺️ Roadmap

- [ ] Exportar reportes de asistencia a Excel/PDF descargables
- [ ] Dashboard con gráficas de estadísticas de puntualidad
- [ ] Autenticación por roles (admin, coordinador, observador)
- [ ] Historial de asistencia por profesor y por periodo
- [ ] Integración con sistemas biométricos de la universidad
- [ ] Modo offline con sincronización posterior

---

## 🤝 Contribución

¡Las contribuciones son bienvenidas! Si deseas mejorar este panel de asistencia:

1. Haz un **Fork** del repositorio
2. Crea una rama (`git checkout -b feature/nueva-funcionalidad`)
3. Haz commit de tus cambios (`git commit -m 'Agrega nueva funcionalidad'`)
4. Sube la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un **Pull Request**

---

## 📄 Licencia

Este proyecto está bajo la licencia **MIT**. Consulta el archivo [`LICENSE`](LICENSE) para más detalles.

---

## 👥 Contacto

**Eder J. Bravo** - [@ebravo-dev](https://github.com/ebravo-dev) - [ederjgb94@gmail.com](mailto:ederjgb94@gmail.com)

---

<div align="center">

**⭐ Si esta herramienta te es útil para la gestión académica, ¡dale una estrella! ⭐**

</div>
