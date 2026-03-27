-- 1
CREATE TABLE section (
    course_id    VARCHAR(8),
    sec_id       VARCHAR(8),
    semester     VARCHAR(6),
    year         NUMERIC(4,0),
    building     VARCHAR(15),
    room_number  VARCHAR(7),
    time_slot_id VARCHAR(4),
    PRIMARY KEY (course_id, sec_id, semester, year),
    FOREIGN KEY (course_id) REFERENCES course,
    FOREIGN KEY (building, room_number) REFERENCES classroom,
    CHECK (semester IN ('Fall', 'Winter', 'Spring', 'Summer'))
);

-- 4
INSERT INTO course VALUES ('BIO-101', 'Intro. to Biology', 'Biology', '4');
