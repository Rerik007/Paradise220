import { useBackend } from "../backend";
import { Box, Section, LabeledList } from "../components";

export const StatusPane = (properties, context) => {
  const { data } = useBackend(context);
  const {
    points, timeleft, moving, at_station, techs,
  } = data;
  {
    techs.map(tech => (
      tech
    ));
  }

  // Shuttle status text
  let statusText;
  if (!moving) {
    if (!at_station)
    { statusText = "Docked off-station"; }

    else
    { statusText = "Docked at the station"; }
  } else {
    statusText = "Shuttle is en route (ETA: " + timeleft + " minutes)";
  }

  return (
    <Box>
      <Section title="Status">
        <LabeledList>
          <LabeledList.Item label="Points Available">
            {points}
          </LabeledList.Item>
          <LabeledList.Item label="Shuttle Status">
            {statusText}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Sent Technologies">
        {techs.map((tech, index) => (
          <Box key={index}> {tech.tech_name}: {tech.tech_level || "0"}</Box>
        ))}
      </Section>
    </Box>
  );
};
