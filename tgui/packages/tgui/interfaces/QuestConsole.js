import { useBackend, useLocalState } from "../backend";
import { Fragment } from 'inferno';
import { Button, Tabs, Box, Flex, Section, Tooltip, Icon, LabeledList, Table } from "../components";
import { Window } from "../layouts";
import { decodeHtmlEntities } from 'common/string';


const getRewardColor = (reward, isCorp) => {
  if (isCorp) { reward /= 10; }

  if (reward > 1100) { return "purple"; }
  if (reward > 500) { return "orange"; }
  if (reward > 250) { return "yellow"; }
  return "green";
};

const mapTwoByTwo = (a, c) => {
  let result = [];
  for (let i = 0; i < a.length; i += 2)
  { result.push(c(a[i], a[i + 1], i)); }
  return result;
};


export const QuestConsole = (properties, context) => {
  const [tabName, setTab] = useLocalState(context, 'tabName', 'centcomm');
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Box fillPositionedParent>
          <Tabs>
            <Tabs.Tab
              key="NT Requests"
              selected={tabName === 'centcomm'}
              onClick={() => setTab('centcomm')}>
              <Icon name="mail-bulk" />
              NT Requests
            </Tabs.Tab>
            <Tabs.Tab
              key="Commercial"
              selected={tabName === 'corporation'}
              onClick={() => setTab('corporation')}>
              <Icon name="dollar-sign" />
              Commercial
            </Tabs.Tab>
            <Tabs.Tab
              key="Plasma Supply"
              selected={tabName === 'plasma'}
              onClick={() => setTab('plasma')}>
              <Icon name="fire" />
              Plasma Supply
            </Tabs.Tab>
            <Tabs.Tab
              key="Management"
              selected={tabName === 'management'}
              onClick={() => setTab('management')}>
              <Icon name="info" />
              Management
            </Tabs.Tab>
          </Tabs>
          {
            tabName === 'management'
              ? (<StatusPane />)
              : (<QuestPane source_customer={tabName} />)
          }
        </Box>
      </Window.Content>
    </Window>
  );
};


const StatusPane = (properties, context) => {
  const { data } = useBackend(context);
  const {
    points,
    timeleft,
    moving,
    at_station,
    techs,
  } = data;

  // Shuttle status text
  let statusText;
  if (moving)
  { statusText = `Shuttle is en route (ETA: ${timeleft} minute${timeleft !== 1 ? 's' : ''})`; }
  else
  if (at_station) { statusText = "Docked at the station"; }
  else { statusText = "Docked off-station"; }

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
        {!techs.length ? (<Box>No tecnologies sent yet</Box>) : (<Box />)}
      </Section>
    </Box>
  );
};


const QuestPane = (properties, context) => {
  const { data } = useBackend(context);
  const { source_customer } = properties;
  const { quests } = data;
  return (
    <Table>
      {
        mapTwoByTwo(quests.filter(quest => quest.customer === source_customer), (quest1, quest2, index) => (
          <Table.Row key={index}>
            <Table.Cell px={2} py={1.25} width="50%" height="1px"><QuestItem quest={quest1} id={index} /></Table.Cell>
            <Table.Cell px={2} py={1.25} width="50%" height="1px">{quest2 ? (<QuestItem quest={quest2} id={index+1} />) : (<Box />)}</Table.Cell>
          </Table.Row>
        ))
      }
    </Table>
  );
};


const QuestFastTimeBonus = properties => (
  <Box position="absolute" right={0.7} top={0.6}>
    <Tooltip content="Fast time bonus active" position="left" />
    <Icon name="fire" size={1.3} color={properties.color || 'average'} />
  </Box>
);


const QuestItem = (properties, context) => {
  const [cardButtonsShown, setCardButtonsShown] = useLocalState(context, `cardButtonsShown`, false);
  const { act } = useBackend(context);
  const { quest } = properties;
  const isCorp = quest.customer === 'corporation';
  const rewardColor = getRewardColor(quest.reward, isCorp);
  return (
    <Section
      title={`Order from ${quest.target_departament}`}
      className={`QuestConsoleSection QuestConsoleSection--${rewardColor} ${(cardButtonsShown === properties.id) && 'QuestConsoleSection--dimmed'} ${(quest.active) && 'QuestConsoleSection--active'}`}
      height="100%" stretchContents position="relative" overflow="hidden"
      onClick={() => setCardButtonsShown(cardButtonsShown !== properties.id ? properties.id : -1)}>
      {(!quest.fast_bonus) || (<QuestFastTimeBonus color={rewardColor} />)}
      <Flex
        className="QuestConsoleSection__content" direction="column" height="78%">
        <Flex.Item>
          <Table>
            {mapTwoByTwo(quest.quests_items, (task1, task2, index) => (
              <Table.Row key={index}>
                <Table.Cell width="50%"><QuestItemTask task={task1} /></Table.Cell>
                <Table.Cell width="50%">{task2 ? (<QuestItemTask task={task2} />) : (<Box />)}</Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Flex.Item>
        <Flex.Item grow={1} basis={1} />
        <Flex.Item>
          <Table>
            <Table.Row>
              <Table.Cell>
                <Box fontSize={1.15}><b>PROFIT:</b> +{quest.reward} {isCorp ? 'credits' : 'points'}</Box>
              </Table.Cell>
              <Table.Cell>
                <Box><b>Time left:</b> {quest.timer}</Box>
              </Table.Cell>
            </Table.Row>
          </Table>
        </Flex.Item>
      </Flex>
      {(cardButtonsShown !== properties.id)
      || (
        <Fragment>
          <Box
            fillPositionedParent
            backgroundColor="black"
            opacity="0.5"
            style={{ 'z-index': '1' }} />
          {
            (!quest.active)
              ? (
                <Box
                  position="absolute" top="50%" left="50%"
                  textAlign="center"
                  style={{ 'z-index': '2', 'transform': 'translate(-50%, -50%)' }}>
                  <Box bold fontSize={1.3} mb={2}>Choose an option:</Box>
                  <Button
                    icon="check" color="green"
                    fontSize={1.2} py={1} px={2}
                    onClick={() => act('activate', { uid: quest.ref })}>
                    Take
                  </Button>
                  <Button
                    ml={2}
                    icon="undo" color="blue"
                    fontSize={1.2} py={1} px={2}
                    onClick={() => act('denied', { uid: quest.ref })}>
                    Reroll
                  </Button>
                </Box>
              ) : (
                <Box
                  position="absolute" top="50%" left="50%"
                  bold fontSize={1.3} textAlign="center"
                  style={{ 'z-index': '2', 'transform': 'translate(-50%, -50%)' }}>
                  The order is already being processed
                </Box>
              )
          }

        </Fragment>)}
    </Section>
  );
};


const QuestItemTask =properties => {
  const { task } = properties;
  return (
    <Flex align="center" position="relative">
      <Flex.Item width={'42px'} mr={1}>
        <Box position="relative">
          <Tooltip
            position="right"
            content={"Send " + task?.quest_type_name} />
          <img
            src={`data:image/jpeg;base64,${task?.image}`}
            style={{
              "-ms-interpolation-mode": "nearest-neighbor",
              'vertical-align': 'middle',
              width: '42px',
              margin: '0px',
            }}
          />
        </Box>
      </Flex.Item>
      <Flex.Item style={{ 'max-width': '160px' }}>{decodeHtmlEntities(task.desc)}</Flex.Item>
    </Flex>
  );
};
