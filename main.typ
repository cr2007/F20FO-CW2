#import "lib.typ": template
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.3": *
#import "@preview/oxifmt:0.2.1": strfmt
#show: codly-init.with()
#codly(languages: codly-languages)

#let data = yaml("metadata.yml")
#let email = strfmt("{}@hw.ac.uk", data.studentEmail)

#set document(
  author: strfmt("{} {}", data.studentFirstName, data.studentLastName),
  title: strfmt("{} {}", data.courseCode, data.courseworkTitle),
)
#set line(length: 100%)
#set rect(stroke: 0.25pt)

#show: template.with()

#text(size: 28pt, font: "Segoe UI Variable", weight: "extrabold", strfmt("{} Coursework 2", data.courseCode))

#text(size: 14pt)[
  #data.courseworkTitle

  #data.studentFirstName #data.studentLastName (#link(strfmt("mailto:{}?subject=F20FO%20Coursework%202%20-%20CSK", email))[#data.studentEmail]) \
  BSc. Computer Science (Hons.) \
  #data.studentID \
]
\

#set align(left)

#outline(indent: 1em)

// \ #align(center, text(size: 20pt, strong[
//   OneDrive Video Link: Forensic Images
// ]))

#line()

#pagebreak()

= Introduction

In the role of a Digital Forensics Analyst assigned to this case, the task was to manage a piece of evidence retrieved
from a suspect. This involved creating two forensically sound images of the seized digital evidence and conducting a
forensic analysis using two designated tools.

This report documents the imaging process, establishes the chain of custody, and outlines the analysis performed on the
provided digital evidence.

#line()

= Forensic Imaging Process

For the initial first task of the assignment, the objective was to create a verifiable forensic image of the seized
digital evidence media. This was achieved using two forensic tools: FTK Imager and #link("http://www.chrysocome.net/dd")[dd for windows].
The forensic image produced with FTK Imager was in EnCase Image (`.E01`) format, whereas the image created with dd for
windows was in Raw Image (`.img`) format.

== FTK Imager

In generating the initial forensic image, FTK Imager was employed to create the first forensic image of the VMWare
virtual disk files. FTK Imager streamlines the process by automatically gathering the accompanying disk files within the
designated directory when the base Virtual Disk file is chosen as the source path, simplifying the procedure.

The steps for creating a verifiable forensic image of the evidence media using FTK Imager are as follows:

#set enum(numbering: "1.a.")

#grid(
  columns: 2,
  [
  + Open FTK Imager
  + Navigate to File > Create Disk Image
  + Choose 'Image File' as the option
  + Specify the Source Path for the Evidence Media
  + Add a destination for the image using the Add Button, selecting the E01 type
  + Provide necessary information for the Evidence Item
  + Select the Image Destination folder and specify the file name
  + Set the Image Fragment Size to 0 to prevent fragmentation
  + Click on '*Start*' to initiate the process

  This process resulted in the creation of an EnCase Image (`.E01`) file, serving as a forensic image of the evidence
  disk, with associated Hash values stored for verification.

  The imaging process was completed within
  approximately 15 minutes.
  ],
  figure(
    caption: "The results page in FTK Imager containing the Hash values after the imaging process.",
    rect(image("images/FTK-Imager_Verify-Results.jpg", height: 6.41cm, alt: "FTK Imager results")),
  ),
)

#pagebreak()

== dd for windows

For the second forensic image, dd for windows, a free, open-source tool developed by #cite(<RN169>, form: "prose") was
utilized for flexible file conversion and copying in a win32 environment. Unlike FTK Imager, dd for windows does not
automatically gather and combine supporting virtual disk files in the Evidence folder. To address this, additional steps
were undertaken before creating a forensic image using dd for windows.

=== VMware-VDiskManager

The initial task involved merging the split-up vmdk files into a single file using the vmware-diskmanager command in
VMware. This command is accessible in VMWare Fusion and VMWare Workstation. For VMWare Player, a separate utility can be
obtained from the VMware website. The process, outlined by #cite(<RN168>, form: "prose") , proceeded as follows:

+ Navigate to the directory where the VMware application is installed\ (typically, `C:\Program Files (x86)\VMware\VMware Workstation` on
  Windows)
+ Make a note of the file path where the VM disk files are located
+ Open Command Prompt and navigate to the directory containing the VM disk files
#enum.item[To merge the files into a single .vmdk file, execute the following command in the terminal:
```sh
"C:\Program Files (x86)\VMware\VMware Workstation\vmware-diskmanager.exe" -r "Path/to/File.vmdk" -t 0 MyNewImage.vmdk
```]

+ The new file will be created.

#figure(
  caption: "A screenshot of the VDiskManager command to merge the vmdk files.",
  image(height: 3.11cm, "images/VDiskManager-Screenshot-Merge-Vmdk.png"),
)

=== Forensic Imaging

Once the combined VM Disk Image was generated, it was utilized to create the forensic image using dd for windows. The
process involved:

+ Downloading and extracting the #link("http://www.chrysocome.net/downloads/dd-0.5.zip")[Binary ZIP package] of the dd
  tool from the Chrysocome website
+ Open Command Prompt in the directory containing the '`dd.exe`' file
#enum.item[Executing the following command in the Command Prompt window:
```sh
.\dd.exe if="file/path/of/evidence.vmdk" of="output/file/path/file.img"
```]

#figure(
  caption: "A screenshot of the dd tool being used in progress to create a forensic image of a disk image.",
  rect(stroke: 0.25pt, image("images/dd-for-windows-Screenshot.png")),
)

The imaging process using *dd for windows* took approximately 2 hours to complete.

#line()

= Forensic Analysis

In the Forensic Analysis phase, the forensic tools Autopsy, and OSForensics were used to analyse the forensic images of
the digital evidence.

Upon initial inspection, it was determined that the system is a Linux machine running the Lubuntu operating system. Six
users were identified by examining the 'home' directory:

+ f21fo-cw2
+ student1
+ student2
+ tutor1
+ user_one
+ user_ten

The primary user, "*f21fo-cw2*", was found to be responsible for all activity on the machine, while the other users
retained only their configurations.

== Password-Protected Word Documents

There were 3 password-protected documents in the machine.


The passwords for the encrypted files were using John the Ripper, a free and open-source password cracking tool, and
Python 2.7 for extracting the passwords for the files.


The following steps, outlined by #cite(<RN170>, form: "prose"), were followed to crack the passwords and examine the
documents:

+ Installed #link("https://www.python.org/downloads/release/python-2718")[Python 2.7.18], the last release of Python 2, as
  of April 2020
+ Installed and extracted #link("https://www.openwall.com/john/doc")[John the Ripper]
+ Copied the `office2john.py` script from John the Ripper to the Python 2.7 directory.
#enum.item[Executed the script against the password-protected file:
```sh
.\python.exe office2john.py <file>.doc
```

#image(width: 14.43cm, "images/John_The_Ripper-Python-Screenshot-Trim.png")
]
+ Recorded the hash values extracted from the Python script
+ Stored the hash value in a text file within the '`john`' directory (the location of the John the Ripper program)
+ Downloaded the #link("https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt")[Rockyou.txt] wordlist
  (\~133MB) and stored it inside the '`john`' directory
+ Ran the John the Ripper program using the Rockyou.txt wordlist to crack the hash values present in the text file (the MS
  Office hashes)
#figure(
  caption: "Command Prompt output of the John the Ripper program",
  rect(stroke: 0.25pt, image(height: 4.5cm, "images/John_The_Ripper-Output.png")),
) \

Analysis of the cracked passwords revealed that they corresponded to specific individuals' contributions to the
scientific community. For instance, passwords referenced Einstein's theory of relativity and Copernicus' foundational
work in astronomy, which often involves the analysis of light across various wavelengths to study celestial objects.

\
== EXIF Images

Further analysis revealed a diverse range of devices used for capturing the images, with most device specifics readily
available either through the file names or within the file metadata.

The brands and models identified in the images are as follows:

#show table.cell.where(y: 0): it => {
  set text(white)
  strong(it)
}

#table(
  columns: (auto, 1fr),
  align: center + horizon,
  fill: (x, y) => if y == 0 { rgb("000000") },
  table.header("Brand", "Models"),
  [Agfa], [DC-504, DC-733s, DC-830i, Sensor505-x, Sensor 530s],
  [Canon], [Ixus55, Ixus70, EX-Z150],
  [Fujifilm], [FinePixJ50],
  [Kodak], [M1063],
  [Nikon], [CoolPix S170, D200, D70, D70s],
  [Olympus], [MJU],
  [Panasonic], [DMC-FZ50],
  [Pentax], [Optio A40, Optio W60],
  [Praktica], [DCZ5.9],
  [Ricoh], [GX100],
  [Rollei], [RCP-7325XS],
  [Samsung], [Galaxy S2, VLUU NV15, VLUU L74],
  [Sony], [DSC-H50, DSC-T77, DSC-W170],
  [ZTE], [Orange San Francisco],
)

The images primarily consisted of outdoor scenery, a cup full of candy, and a teacup, captured from various
perspectives. Additionally, numerous random images of books, roads, and outdoor scenes were observed.

\ #line()

== Bash History

#grid(
  columns: 2,
  column-gutter: 0.5em,
  [
    Upon further examination of the forensic image using OSForensics, attention was drawn to the '*.bash_history*' file,
    housing the command history for the Bash shell, generated for each user within their respective '*home*' directory.

    An observation was made regarding the user's attempts to install the Wine library, enabling Windows applications to run
    on Linux systems.
  ],
  figure(
    caption: [A screenshot of the contents of the '*.bash_history*' file.],
    rect(stroke: 0.25pt, image("images/Bash_History_File_Contents.png")),
  ),
)

Subsequently, the user attempted to execute the Wine tool on 'slacker.exe' and then utilize the 'timestomp' tool. A
quick online search revealed that 'slacker.exe' is a tool for concealing secret data in stack space @RN172, while
Timestomp is a technique for altering file timestamps @RN173.

An unusual aspect was noted wherein the user initially attempted to run the '`wine`' command before installing the '`wine-stable`' package.
The first line in the file denotes the first command successfully executed in the system, followed by subsequent
commands.

Additionally, it was observed that the user generated an *RSA key pair* with a key length of 4096 bits. They then
attempted to decipher the contents of the RSA key using John the Ripper, specifically via the '*ssh2john*' Python
script, with the output redirected to the '*id_rsa.hash*' file.

\ #line()
#pagebreak()

== Issues Faced

#grid(
  columns: 2,
  [During the forensic analysis, encountering issues with OSForensics was very common. Certain sections or functionalities
    of the application would always trigger errors, leading to the generation of debug reports and automatic closure of the
    app, as illustrated by the screenshot.],
  figure(
    caption: "Screenshot of the error message displayed by the OSForensics tool",
    image("images/OSForensics-Error_Message.png"),
  ),
)

\ #line()

= Conclusion

In conclusion, this report outlines the tasks undertaken in a case involving digital evidence retrieved from a suspect.
The assignment involved creating forensically sound images of the evidence and conducting a thorough forensic analysis.
The findings reveal significant insight into the user's activities, including attempts to conceal the data and modify
timestamps using specialized tools. Additionally, the discovery of password-protected documents and the cracking of
their passwords provides further context to the case.

The thorough examination of the Bash history file uncovered the user's efforts to leverage the Wine library to execute
Windows applications on the Linux system, as well as the generation of an RSA key pair and subsequent attempts to
decipher its contents. These observations suggest the suspect's familiarity with various forensic tools and techniques,
potentially indicating an advanced understanding of digital forensics.

Overall, the comprehensive forensic analysis of the evidence provides valuable information that can aid in the ongoing
investigation. The detailed documentation of the imaging process and the comprehensive chain of custody contribute to
the forensic integrity of the evidence, ensuring its admissibility in any legal proceedings. The insights gained from
this analysis will undoubtedly prove instrumental in the progression of the case.

\ #line()
#pagebreak()

= Appendix

== Chain of custody

#table(
  columns: (auto, auto, 1fr),
  align: center + horizon,
  fill: (x, y) => if y == 0 { rgb("000000") },
  table.header("Date", "Time", "Action"),
  [March 19, 2024], [17:44], [Acquired Digital Evidence from Line Manager (Course Leader)],
  [March 21, 2024], [19:18], [Created Forensic Image 1 using 'FTK Imager'],
  [March 28, 2024], [00:22], [Created Forensic Image 2 using 'dd for windows'],
  [March 30, 2024], [17:50], [Created Autopsy case using the Forensic Image],
  [March 31, 2024], [03:52], [Autopsy case setup (Ingest) completed],
  [April 2, 2024], [08:45], [Setup New Case in OSForensics],
)

\ #line()

// --------------------------------

#bibliography(title: "References", "bibliography.bib", style: "harvard-cite-them-right")
