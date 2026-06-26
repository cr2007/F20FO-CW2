# F20FO Coursework 2: Digital Forensics Investigation

Report for the F20FO (Digital Forensics) Coursework 2 report at Heriot-Watt University.

## Report structure

- **Forensic Imaging**: forensic images created with FTK Imager (`.E01`) and dd for Windows (`.img`), including vmdk merging via VMware VDiskManager
- **Forensic Analysis**: Autopsy and OSForensics examination covering password cracking (John the Ripper), EXIF metadata, and Bash history review
- **Chain of custody**: timestamped evidence handling log

## Building

Copy the example metadata file and fill in your details, then compile:

```sh
cp example.metadata.yml metadata.yml
typst compile main.typ coursework.pdf
```

Requires Typst packages: [`codly@1.3.0`](https://typst.app/universe/package/codly/), [`codly-languages@0.1.3`](https://typst.app/universe/package/codly-languages), [`oxifmt@0.2.1`](https://typst.app/universe/package/oxifmt).

## CI/CD

Pushes to `master` compile the report and deploy it to GitHub Pages. The following repository secrets must be set:

| Secret | Description |
|---|---|
| `STUDENT_FIRST_NAME` | First name |
| `STUDENT_LAST_NAME` | Last name |
| `STUDENT_EMAIL` | HW email prefix (e.g. `ab1234`) |
| `STUDENT_ID` | Student ID (e.g. `H00123456`) |

## Project structure

```
.
├── main.typ              # Report source
├── lib.typ               # Page template and shared utilities
├── bibliography.bib      # References (Harvard)
├── example.metadata.yml  # Metadata template (copy to metadata.yml)
├── images/               # Screenshots referenced in the report
└── .github/workflows/
    └── deploy.yml        # Build and deploy to GitHub Pages
```
